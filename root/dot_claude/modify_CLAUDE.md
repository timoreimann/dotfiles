{{- /* chezmoi:modify-template */ -}}
{{- /* Claude Code imports the instruction files. Each chezmoi source adds the
       import of its own file in its own section. The base section comes
       first. */ -}}
{{- includeTemplate "section" (dict "stdin" .chezmoi.stdin "name" "base" "content" "@~/.config/agent-instructions/base.md" "comment" "<!-- %s -->" "first" true) -}}
