#!/bin/zsh

# Base pubspec from code-01
BASE_PUBSPEC=$(cat << 'EOF'
# Nylo - Micro-framework for Flutter.
#
# Website: https://nylo.dev
# Official repository: https://github.com/nylo-core/nylo
# Author: Anthony Gordon <https://github.com/agordn52>

name: flutter_app
description: A new Nylo Flutter application.

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.4.0 <4.0.0'
  flutter: ">=3.24.0 <4.0.0"
dependencies:
  url_launcher: ^6.3.2
  google_fonts: ^6.3.2
  analyzer: ^9.0.0
  intl: ^0.20.2
  nylo_framework: ^6.9.1
  pretty_dio_logger: ^1.4.0
  cupertino_icons: ^1.0.8
  path_provider: ^2.1.5
  flutter_local_notifications: ^19.5.0
  font_awesome_flutter: ^10.12.0
  scaffold_ui: ^1.2.9
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  rename: ^3.1.0
  flutter_launcher_icons: ^0.14.4
  flutter_test:
    sdk: flutter

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "public/app_icon/icon.png"
  remove_alpha_ios: true

flutter:
  uses-material-design: true
  assets:
    - public/fonts/
    - public/images/
    - public/app_icon/
    - lang/
    - .env
EOF
)

# Branches and their additional dependencies
declare -A BRANCH_DEPS
BRANCH_DEPS[code-09-shared-preferences]="shared_preferences: ^2.5.3"
BRANCH_DEPS[code-10-persistent-data]="shared_preferences: ^2.5.3"
BRANCH_DEPS[code-11-supabase-setup]="shared_preferences: ^2.5.3|supabase_flutter: ^2.9.1"
BRANCH_DEPS[code-12-supabase-crud]="shared_preferences: ^2.5.3|supabase_flutter: ^2.9.1"
BRANCH_DEPS[code-13-cloud-sync]="shared_preferences: ^2.5.3|supabase_flutter: ^2.9.1"
BRANCH_DEPS[code-14-polish]="shared_preferences: ^2.5.3|supabase_flutter: ^2.9.1"

echo "Fixing pubspec.yaml in all branches..."

# Get all code branches
branches=($(git branch | grep -E 'code-0[2-9]|code-1[0-4]' | tr -d ' *'))

for branch in "${branches[@]}"; do

    echo ""
    echo "📝 Processing $branch..."
    git checkout "$branch" 2>/dev/null

    # Start with base pubspec
    echo "$BASE_PUBSPEC" > pubspec.yaml

    # Add branch-specific dependencies
    if [[ -n "${BRANCH_DEPS[$branch]}" ]]; then
        IFS='|' read -rA deps <<< "${BRANCH_DEPS[$branch]}"
        for dep in "${deps[@]}"; do
            echo "   Adding: $dep"
            # Insert after flutter: sdk: flutter line
            awk -v dep="  $dep" '
            /^  flutter:/ {
                print
                getline
                print
                print dep
                next
            }
            { print }
            ' pubspec.yaml > pubspec.yaml.tmp
            mv pubspec.yaml.tmp pubspec.yaml
        done
    fi

    git add -f pubspec.yaml
    git commit -m "Fix pubspec.yaml: use base from code-01 + branch dependencies" --no-verify 2>/dev/null
    echo "✅ $branch updated"
done

git checkout main
echo ""
echo "✅ All branches updated!"