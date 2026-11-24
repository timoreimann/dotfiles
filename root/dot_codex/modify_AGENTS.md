{{- /* chezmoi:modify-template */ -}}
{{- /* Codex reads only this file and does not expand imports, so each chezmoi
       source copies its instruction file into its own section. The base
       section comes first. */ -}}
{{- $content := printf "<!-- chezmoi builds this file from the files in ~/.config/agent-instructions. Edit those files instead. -->\n\n%s" (include "dot_config/agent-instructions/base.md") -}}
{{- includeTemplate "section" (dict "stdin" .chezmoi.stdin "name" "base" "content" $content "comment" "<!-- %s -->" "first" true) -}}
