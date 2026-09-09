#!/bin/bash
#
# theme_audit.sh
#
# 审计 DTBKit 主题 json 的 key 引用情况，输出四类：
#
#   1) 无人直接引用的 key（死 key）
#        json 里定义了，但既没有「代码字面量」直接引用，也没有 json 内部「值引用」。
#        注意：其中的一部分可能是「漏加前缀」导致的假死 key，需结合第 3 节看。
#
#   2) 疑似漏加 dtb. 前缀（可疑）
#        代码里存在「无 dtb. 前缀」的字符串字面量 L，且 "dtb.L" 恰好是某个 json 的 key。
#        典型是 keys 数组 + .dtb.create($0) 这类间接引用，迁移脚本的纯字面量正则会漏掉。
#
#   3) 变量引用（可疑）
#        .dtb.create($0) / .style($0) 等，key 来自变量，无法静态确定，需人工核对。
#
#   4) 存在后覆盖（同名 key）
#        同一个 key 出现在多个 json，bundle 链合并时后加载的覆盖先加载的。
#
# 用法:
#   bash Scripts/theme_audit.sh [主题目录] [代码搜索目录...]
#
# 默认:
#   主题目录  = Sources/Resources/SportTheme
#   代码目录  = Sources  Example/Codes
#
# 依赖: jq, perl
#
# LICENSE: SAME AS REPOSITORY
# Contact me: [GitHub](https://github.com/darkThanBlack)

set -euo pipefail

# 定位仓库根目录（脚本位于 <root>/Scripts/theme_audit.sh），
# 这样无论从哪个目录执行，默认相对路径都指向仓库根。
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

THEME_DIR="${1:-Sources/Resources/SportTheme}"
shift 2>/dev/null || true
if [ "$#" -eq 0 ]; then
    CODE_DIRS=(Sources Example/Codes)
else
    CODE_DIRS=("$@")
fi

# 需要审计的 json（排除 Lottie 动画 hud01/hud02 与 xcassets/Contents.json）
JSON_FILES=(colors string_zh shape_style gradient_style container_style text_style button_style)

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# DTBKit 手写 json 存在非法 trailing comma，读取前先剔除
clean_json() { sed -E 's/,[[:space:]]*([}\]])/\1/g' "$1"; }

missing=0
for f in "${JSON_FILES[@]}"; do
    if [ ! -f "$THEME_DIR/$f.json" ]; then
        echo "警告: 缺失 $THEME_DIR/$f.json" >&2
        missing=1
    fi
done

# ---- 收集 json 顶层 key ----
for f in "${JSON_FILES[@]}"; do
    [ -f "$THEME_DIR/$f.json" ] || continue
    clean_json "$THEME_DIR/$f.json" | jq -r 'keys[]'
done | sort -u > "$TMP/all_keys.txt"

# ---- key → 文件 映射（供死 key 分类 / 后覆盖使用）----
for f in "${JSON_FILES[@]}"; do
    [ -f "$THEME_DIR/$f.json" ] || continue
    clean_json "$THEME_DIR/$f.json" | jq -r --arg f "$f.json" 'keys[] | "\(.)\t\($f)"'
done | sort > "$TMP/key_file.txt"

# ---- 收集 json 内部「值引用」：值是另一个 key 的字符串 ----
for f in "${JSON_FILES[@]}"; do
    [ -f "$THEME_DIR/$f.json" ] || continue
    clean_json "$THEME_DIR/$f.json" | jq -r '.. | strings'
done | sort -u > "$TMP/all_vals.txt"
comm -12 "$TMP/all_vals.txt" "$TMP/all_keys.txt" > "$TMP/val_refs.txt"

# ---- 收集代码「主题调用」参数里的所有字面量（简单 + 三元/表达式）----
find "${CODE_DIRS[@]}" -name '*.swift' -type f 2>/dev/null -print0 \
    | xargs -0 perl -ne '
        next if /^\s*(?:\/\/|\/\*|\*)/;   # 跳过纯注释行
        s{//.*?$}{};                       # 去掉行内注释
        while (/(?:\.dtb\.create|\.style|textStyle)\(([^)]*)\)/g) {
            my $a = $1;
            while ($a =~ /"([a-zA-Z0-9_.]+)"/g) { print "$1\n"; }
        }
      ' | sort -u > "$TMP/code_literals.txt"

# 直接引用 = 主题调用参数里、且是 dtb. 前缀的 json key
comm -12 "$TMP/code_literals.txt" "$TMP/all_keys.txt" > "$TMP/direct_refs.txt"

# ---- 收集代码里「无 dtb. 前缀」的类 key 字面量（全局，用于漏前缀检测）----
find "${CODE_DIRS[@]}" -name '*.swift' -type f 2>/dev/null -print0 \
    | xargs -0 perl -ne '
        next if /^\s*(?:\/\/|\/\*|\*)/;   # 跳过纯注释行
        s{//.*?$}{};                       # 去掉行内注释
        while (/"([a-zA-Z][a-zA-Z0-9_.]*)"/g) { print "$1\n"; }
      ' | grep -v '^dtb\.' | sort -u > "$TMP/plain_literals.txt"

# 漏前缀：无前缀字面量 L，且 "dtb.L" 是 json key
sed 's/^/dtb./' "$TMP/plain_literals.txt" | sort -u > "$TMP/plain_prefixed.txt"
comm -12 "$TMP/plain_prefixed.txt" "$TMP/all_keys.txt" > "$TMP/leak_dtb.txt"
sed 's/^dtb\.//' "$TMP/leak_dtb.txt" > "$TMP/leak_plain.txt"

# ---- 变量引用（可疑）：主题调用参数以 $ 开头 ----
find "${CODE_DIRS[@]}" -name '*.swift' -type f 2>/dev/null -print0 \
    | xargs -0 grep -nHE '(\.dtb\.create|\.style|textStyle)\(\$' 2>/dev/null \
    > "$TMP/var_refs.txt" || true

# 裸标识符变量引用（低置信：可能含解析层/非主题的 .dtb.create）
find "${CODE_DIRS[@]}" -name '*.swift' -type f 2>/dev/null -print0 \
    | xargs -0 grep -nHE '(\.dtb\.create|\.style|textStyle)\([a-zA-Z_][a-zA-Z0-9_]*\)' 2>/dev/null \
    > "$TMP/var_refs_ident.txt" || true

# ---- 全部引用 = 直接引用 ∪ 值引用 ----
cat "$TMP/direct_refs.txt" "$TMP/val_refs.txt" | sort -u > "$TMP/all_refs.txt"

echo "主题目录: $THEME_DIR"
echo "代码目录: ${CODE_DIRS[*]}"
echo ""

# ---- 1) 死 key（按 json 分类）----
echo "=============================================="
echo "1) 无人直接引用的 key（死 key，按 json 分类）"
echo "=============================================="
comm -23 "$TMP/all_keys.txt" "$TMP/all_refs.txt" > "$TMP/dead.txt"

# dead_file.txt: file \t key（关联死 key 与所属文件）
awk -F'\t' '
    NR==FNR { dead[$1]=1; next }
    ($1 in dead) { print $2 "\t" $1 }
' "$TMP/dead.txt" "$TMP/key_file.txt" | sort > "$TMP/dead_file.txt"

total=0
if [ ! -s "$TMP/dead.txt" ]; then
    echo "  （无）"
else
    for f in "${JSON_FILES[@]}"; do
        file_dead="$(awk -F'\t' -v f="$f.json" '$1 == f { print $2 }' "$TMP/dead_file.txt")"
        [ -z "$file_dead" ] && continue
        count="$(printf '%s\n' "$file_dead" | wc -l | tr -d ' ')"
        echo "  $f.json（$count 个）"
        printf '%s\n' "$file_dead" | sed 's/^/    - /'
        total=$((total + count))
    done
fi
echo "  —— 共 $total 个"
echo "  （其中一部分可能是「漏前缀」假死 key，见第 2 节）"
echo ""

# ---- 2) 漏前缀可疑 ----
echo "=============================================="
echo "2) 疑似漏加 dtb. 前缀（可疑）"
echo "=============================================="
if [ ! -s "$TMP/leak_plain.txt" ]; then
    echo "  （无）"
else
    while IFS= read -r lit; do
        echo "  - $lit  →  dtb.$lit"
        grep -rn "\"$lit\"" "${CODE_DIRS[@]}" --include='*.swift' 2>/dev/null \
            | grep -vE ':[[:space:]]*(//|/\*|\*)' \
            | head -3 | sed 's/^/      /'
    done < "$TMP/leak_plain.txt"
fi
echo "  —— 共 $(wc -l < "$TMP/leak_plain.txt" | tr -d ' ') 个"
echo ""

# ---- 3) 变量引用可疑 ----
echo "=============================================="
echo "3) 变量引用（可疑，key 无法静态确定）"
echo "=============================================="
if [ ! -s "$TMP/var_refs.txt" ]; then
    echo "  （无）"
else
    sed 's/^/  - /' "$TMP/var_refs.txt"
fi
echo "  —— 共 $(wc -l < "$TMP/var_refs.txt" | tr -d ' ') 个"
echo ""
echo "  （低置信）裸标识符引用（可能含解析层/非主题 .dtb.create）："
if [ ! -s "$TMP/var_refs_ident.txt" ]; then
    echo "    （无）"
else
    sed 's/^/    - /' "$TMP/var_refs_ident.txt"
fi
echo ""

# ---- 4) 后覆盖 ----
echo "=============================================="
echo "4) 存在后覆盖的 key（同名出现在多个 json，后者覆盖前者）"
echo "=============================================="
cut -f1 "$TMP/key_file.txt" | sort | uniq -d > "$TMP/dup_keys.txt"

if [ ! -s "$TMP/dup_keys.txt" ]; then
    echo "  （无）"
else
    while IFS= read -r k; do
        echo "  - $k"
        awk -F'\t' -v k="$k" '$1 == k { print "      - " $2 }' "$TMP/key_file.txt"
    done < "$TMP/dup_keys.txt"
fi
echo "  —— 共 $(wc -l < "$TMP/dup_keys.txt" | tr -d ' ') 个"
