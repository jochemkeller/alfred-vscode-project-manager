: ${root:=~/Developer}
: ${mindepth:=2}
: ${maxdepth:=2}

find -L "${root}" -type d -mindepth "${mindepth}" -maxdepth "${maxdepth}" | sed -e 's|/Users/jochem/Developer/||' | fzf --exact --filter="$1" | jq -nR '
	[inputs]
	|
	map({
		uid: ("/Users/jochem/Developer/" + .),
		title: split("/")[-1],
		subtitle: "~/Developer/\(split("/")[0])",
		arg: ("/Users/jochem/Developer/" + .),
		autocomplete: ("/Users/jochem/Developer/" + .),
		icon: {
			type: "fileicon",
			path: ("/Users/jochem/Developer/" + .)
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