icloud () {
	: the iCloud documents directory
	: defaults to cd, try pushd, ls -l, echo, ...
	: date: 2020-12-04 -- MMIII modification
	${@:-cd} ~/Library/Mobile\ Documents/com~apple~CloudDocs/
}
