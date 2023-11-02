: ${root:=~/Developer}

: ${mindepth:=2}
: ${maxdepth:=2}

: ${remotes:=''}
: ${remotedirs:=''}

pattern="code -n --remote ssh-remote+"

remotesmap=""

while IFS= read -r -u3 x; IFS= read -r -u4 y; do
  remotesmap+="$pattern$x $y\n"
done 3<<<"$remotes" 4<<<"$remotedirs"

find -L "${root}" -type d -mindepth "${mindepth}" -maxdepth "${maxdepth}" | sed -e 's|/Users/jochem/Developer/||' | (cat;echo $remotesmap) | fzf --exact --filter="$1" | jq -nR --arg jq_pattern "$pattern" '
	[inputs]
	|
	map({
		uid: (. |= if contains($jq_pattern) then . else "/Users/jochem/Developer/" + . end),
		title: (. |= if contains($jq_pattern) then . else split("/")[-1] end) | gsub("\($jq_pattern)"; "") | gsub("\\+"; "") | split("/")[0],
		subtitle: (. |= if contains($jq_pattern) then . else "~/Developer/\(split("/")[0])" end),
		arg: (. |= if contains($jq_pattern) then . else "/Users/jochem/Developer/" + . end),
		autocomplete: (. |= if contains($jq_pattern) then . else "/Users/jochem/Developer/" + . end),
		icon: {
			path: (. |= if contains($jq_pattern) then "./ssh.png" else "./vs-code.png" end)
		}
	})
	|
	{ items: . }
	|
	if .items != [] then
		.
	else
		{
			items: [{
				title: "Nothing found",
				subtitle: "Try again with another query!",
			}]
		}
	end
'