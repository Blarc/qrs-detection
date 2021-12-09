rm -f eval1.txt
rm -f eval2.txt

if [ -z "$1" ]; then
	printf "ERROR: No path provided!\n" 
	exit 1
fi

FILES="$1"
cd "$FILES"

for f in *.asc; do
	basename=$(basename "$f")
	basename="${basename%.*}"
	basename="${basename::-1}"

	printf "%s : %s\n" "$f" "$basename"

	wrann -r "$basename" -a qrs <"$f"
	bxb -r "$basename" -a atr qrs -l ../eval1.txt ../eval2.txt
done

cd ..
sumstats eval1.txt eval2.txt >results.txt