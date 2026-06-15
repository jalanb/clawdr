pull fred:
    just pull-{{fred}}

push fred:
    just push-{{fred}}

pull-plan:
    cp /Users/jab/.claude/plans/dapper-churning-lagoon.md ./PLAN.md

push-plan:
    cp ./PLAN.md /Users/jab/.claude/plans/dapper-churning-lagoon.md

pull-skill fred:
    cd skills/{{fred}} && test -f justfile && just pull

push-skill fred:
    cd skills/{{fred}} && test -f justfile && just push

pull-skills:
    #! /usr/bin/env bash
    for dir in skills/*/; do
        [ -f $dir/justfile ] || continue
        (cd $dir && just pull);
    done

push-skills:
    #! /usr/bin/env bash
    for dir in skills/*/; do
        [ -f $dir/justfile ] || continue
        (cd $dir && just push);
    done

pull-commands:
    cd commands && just pull

push-commands:
    cd commands && just push

add-bash skill="fred":
    #!/usr/bin/env bash
    set -euo pipefail
    test -f skills/{{skill}}/src/SKILL.md || { echo "Unknown skill: {{skill}}"; exit 1; }
    jrender() { test -f "$2" || jinja2 "$1" -D name={{skill}} -o "$2"; }
    fd -e j2 templates/bash | while read -r f; do
        rel="${f#templates/bash/}"
        dst="${rel/name/{{skill}}}"
        dst="${dst%.j2}"
        jrender "$f" "skills/{{skill}}/$dst"
    done

add-python skill="fred" level="python":
    #!/usr/bin/env bash
    set -euo pipefail
    test -f skills/{{skill}}/src/SKILL.md || { echo "Unknown skill: {{skill}}"; exit 1; }
    test -d templates/{{level}} || { echo "Unknown level: {{level}}"; exit 1; }
    jrender() { test -f "$2" || jinja2 "$1" -D name={{skill}} -o "$2"; }

    if [ "{{level}}" = "package" ]; then
        mkdir -p skills/{{skill}}/src/{{skill}}
    fi

    fd -e j2 templates/{{level}} | while read -r f; do
        rel="${f#templates/{{level}}/}"
        dst="${rel/name/{{skill}}}"
        dst="${dst%.j2}"
        jrender "$f" "skills/{{skill}}/$dst"
    done

    if [ "{{level}}" = "package" ]; then
        src="skills/{{skill}}/src/{{skill}}.py"
        main="skills/{{skill}}/src/{{skill}}/__main__.py"
        if [ -f "$src" ] && [ "$(wc -l < "$src")" -gt "$(wc -l < "$main")" ]; then
            mv "$src" "$main"
        fi
    fi

new-skill-deps:
    which jinja2 || brew install jinja2-cli

new-skill name="fred" : new-skill-deps
    #!/usr/bin/env bash
    set -euo pipefail
    jrender() { test -f "$2" || jinja2 "$1" -D name={{name}} -o "$2"; }

    mkdir -p skills/{{name}}/src
    jrender templates/.gitignore.j2 skills/{{name}}/.gitignore
    jrender templates/README.md.j2 skills/{{name}}/README.md
    jrender templates/justfile.j2   skills/{{name}}/justfile
    for f in templates/src/*.j2; do
        jrender "$f" "skills/{{name}}/src/$(basename "$f" .j2)"
    done
    #
    # We need sections for no python, one script or package
    # Here, we assume no python
    #    jrender templates/pypackage/pyproject.toml.j2 skills/{{name}}/pyproject.toml
    vim -p skills/{{name}}/src/SKILL.md skills/{{name}}/README.md
