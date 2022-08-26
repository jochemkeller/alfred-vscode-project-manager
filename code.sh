find -L ~/Developer -type d -mindepth 2 -maxdepth 2 | fzf --exact --filter="$1" | jq -nR '
	[inputs]
	|
	map({
		uid: .,
		title: split("/")[-1],
		subtitle: "~/\(split("/")[3:-1]|join("/"))",
		arg: .,
		autocomplete: .,
		icon: {
			type: "fileicon",
			path: .
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