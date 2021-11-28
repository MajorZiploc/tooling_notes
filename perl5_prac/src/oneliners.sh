# take the first 5 lines | then print the range 2..4
cat numed.txt | perl -pe 'exit if $. eq 6' | perl -lne 'print $_ if 2..4'

# print lines 15 to 17 of file foo.txt
perl -ne 'print if 15 .. 17' foo.txt

# a second way to print lines 3 to 5 of file foo.txt
perl -pe 'exit if 3<$. && $.<5' foo.txt

# change all words "foo"s to "bar"s in every .c file and keep backups
perl -p -i.bak -e 's/\bfoo\b/bar/g' *.c

# the same but without backup. Remember the flags: "eat the pie"
perl -p -i -e 's/foo/bar/g' *.c

# changes ^M newline characters to newlines
perl  -p -i -e 's/\012?\015/\n/g'  $1

# substitution can also be applied to binary files like test.ppm
perl -p -i -e 's/255/127/g' test.ppm

# insert department name after each title and keep backup
perl -p -i.bak -e 's#<title>#<title>Harvard .: #i' *.html

# delete first 10 lines in foo.txt and keep backup foo.txt.bak
perl -i.bak -ne 'print unless 1 .. 10' foo.txt

# change isolated occurrence of aaa to bbb in each file *.c or *.h
perl -p -i.bak -e 's{\baaa\b}{bbb}g' *.[ch]

# reverses lines of file foo.txt and print it
perl -e 'print reverse <>' foo.txt

# find palindromes in a dictionary /usr/share/dict/words
perl -lne 'print if $_ eq reverse' /usr/share/dict/words

# reverses paragraphs in file foo.txt
perl -00 -e 'print reverse <>' foo.txt

# increments all numbers in foo.txt by 1
perl -pe 's/(\d+)/ 1 + $1 /ge' foo.txt

# reverses order of characters in each line of foo.txt
perl -nle 'print scalar reverse $_' foo.txt

# look for duplicated words in a line
perl -0777 -ne 'print "$.: doubled $_\n" while /\b(\w+)\b\s+\b\1\b/gi' foo.txt

# start Perl debugger "stand-alone"
perl -d -e 42

# run a Perl program program.pl with warnings
perl -w program.pl

# run a Perl program program.pl with debugger
perl -d program.pl

# Run perl program program.pl, check syntax, print warnings
perl -wc program.pl

# filters stdin to include lines with only the word 'two', then displays the number of matches
perl -nle 'print $_ and $c++ if m~two~; END {print "Done"}'

# get all urls from img tags, can pipe curl output to this to get the urls
# be careful when using regex on html
perl -nle 'print $+ if m~<img.?src="(.?)".*?>~'

# this will get all urls from the specified website, then will give to wget to download them to your machine in the relative path ./images
# be careful when using regex on html
curl -s https://www.popsci.com/red-skulls-look-purple-and-orange | perl -nle 'print $+ if m~<img.?src="(.?)".*?>~' | xargs wget -P ./images

# xargs --- can be used to make the stdout of a one command, the input of another command.
# Useful for when you get a list from one cmd and the other cmd only takes 1 arg

# adding text in front and behind every line
perl -ple '$_ = "text before " . $_ . "text after"'

# meta::cpan /// repo of perl libs, easy to find good modulesfrom cli do: cpan <lib_name> // to install lib_name

# moves folder and files from current folder to the notes folder at the home folder
ls | xargs mv -t ~/notes

# deletes multiple files that match grep pattern
ls -ah | grep -ie '.*~$' | xargs rm

# counts nonempty lines in a file
cat engpaper.txt | perl -nle '$c++ if m~.~; END{print $c}'

# counts empty lines in a file
cat engpaper.txt | perl -nle '$c++ if m~^$~; END{print $c}'

# List / number examples BEGIN

# NOTE! perl examples that do list operations use space delimited lists be default.
# the -F flag can be used to change the delimiter.
# example of lines
# 3 -11 100
# 4

# sum all number on a line
cat number.txt | perl -MList::Util=reduce -alne 'print reduce {$a + $b} @F'

# add 1 to every number on the line for every line. .map()
cat number.txt | perl -alne 'print map {$_ + 1} @F'

# multiply elements on every line that are unique. .reduce()
cat number.txt | perl -MList::Util=reduce,uniq -alne 'print reduce {$a * $b} (uniq @F)'

# add 1 to all unique elements on a line and then multiply the results. .reduce()
cat number.txt | perl -MList::Util=reduce,uniq -alne 'print reduce {$a * $b} (map {$_ + 1}(uniq @F))'

# for each line: filters out numbers 1 or less, keeps the unique numbers, adds 1 to each number, then multiplies all numbers on the line. .reduce(), .map(), .filter()
printf '1 2 2 3 4 2 2 1\n1\n99 2' | perl -MList::Util=reduce,uniq -alne 'print reduce {$a * $b} (map {$_ + 1}(uniq (grep {$_ > 1} @F)))'

# for each line: gets unique elements, filters out numbers that are 1 or less, adds one to the remaining numbers, then multiplies the results together.
cat number.txt | perl -MList::Util=reduce,uniq -alne 'print reduce {$a * $b} (map {$_ + 1}((grep {$_ > 1} uniq @F)))'

# change the delimiter with -F
printf '4:1:9:9:1\n3\n' | perl -MList::Util=reduce -F: -alne 'print reduce {$a + $b} @F'

# NOTE: push can put a single scalar into a list, or a lists eles into a list like cat
# put all eles from @F (each line with eles split by :) into @S.
# @S will have all eles by the end of file and will reduce them to one value
printf '4:1:9:9:1\n3\n' | perl -MList::Util=reduce -F: -alne 'push @S,@F; END{print reduce {$a + $b} @S}'

# Same as last one. but reduces each line to a scalar before puting in @S
printf '4:1:9:9:1\n3\n' | perl -MList::Util=reduce -F: -alne 'push @S,(reduce {$a + $b}@F); END{print reduce {$a + $b} @S}'

# same as last one
printf '4:1:9:9:1\n3\n' | perl -MList::Util=reduce -F: -alne '$s += (reduce {$a + $b}@F); END{print $s'}

# number of eles in file
printf '4:1:9:9:1\n2\n' | perl -F: -alne '$s += @F; END{print $s}'

# count of eles on each line in file
printf "4:2:2:1\n1" | perl -F: -MList::Util=reduce -alne '$x=(scalar @F)? (-@F[0])+1 : 0; print ((reduce {$a + 1} @F) + $x)'

# count number of lines that have a passing element
printf '4:1:9:9:1\n3\n7' | perl -MList::Util=any -F: -alne '$s += any {$_ > 13} @F; END{print $s'}

# print the lines that have a passing element
printf '4:1:9:9:1\n3\n17' | perl -MList::Util=any -F: -alne 'print $_ if any {$_ < 13} @F'

# print the absolute value of eles
printf '4:1:9:9:1\n-3\n17' | perl -F: -alne 'print "@{[(map {abs} @F)]}"'printf '4:1:9:9:1\n3\n17' | perl -F: -alne 'print join " ", (map {abs($_)} @F)'

# generate a random password of size 8
perl -le '@arr = ("a".."z", 0..9); print map {@arr[rand 36]} 1..8;'

# convert characters to ascii values
printf 'sam hi' | perl -lne 'print $_," : ", (join " ", map {ord} (split //, $_))'

# finds numbers in a tab separated file and adds 1 to them
perl -MScalar::Util=looks_like_number -alne 'print join "\t", (map {(looks_like_number $_) ? $_ + 1 : $_} @F)' tabdata.txt

# shuffle lines in a file, this puts all lines into memory
cat names.txt | perl -MList::Util=shuffle -nle 'push(@M,$_); END{print (join "\n", (shuffle @M))}'// same thingcat names.txt | perl -MList::Util -e 'print List::Util::shuffle <>'

# pairing xmas names first try
cat names.txt | perl -MList::Util -nle 'push(@M,$_); END{print join ":-:", @M}' | perl -MList::MoreUtils=zip,pairwise -MList::Util=shuffle -F:-: -ale '@M=@F; @M2 = shuffle @M;@L=zip @F, @M2;print join "\n", pairwise {$a."->".$b} @F, @M2'

# pairing xmas names second try, ppl can still be assigned self
cat names.txt | perl -MList::Util -nle 'push(@M,$_); END{print join ":-:", @M}' | perl -MList::MoreUtils=pairwise -MList::Util=shuffle -F:-: -ale '@M=shuffle @F; print join "\n", pairwise {$a." -> ".$b} @F, @M'

# pairing xmas names third try, ppl can still be assigned self, but gives a error on the lines that are self assigned
cat names.txt | perl -MList::Util -nle 'push(@M,$_); END{print join ":-:", @M}' | perl -MList::MoreUtils=pairwise -MList::Util=shuffle -F:-: -ale '@M=shuffle @F; print join "\n", pairwise {($a eq $b)? $a." -> ".$b." Problem!!!" : $a." -> ".$b} @F, @M'

# gets all files from a directory (non-recursively) and sums up all of the word counts.. (can just stop at wc -l aswell)
ls -p | grep -v / | xargs wc -l | perl -ple "s/^\s+//" | cut -f1 -d " " | head -n -1 | tr "\n" ":" | perl -MList::Util=reduce -F: -nle 'print (reduce {$a + $b}@F)'

# List / number examples END

# REGEX examples BEGIN

# if a line contains 'monkey' then lowercase all words, fix spacing and then titlecase the line
# ONLY APPLIES THE IF TO THE LAST STATEMENT, EVERYTHING ELSE HAPPENS FOR ALL LINES
perl -ple 's/(\w+)/\l$1/g; s/(\s)+/ /g; s/(\w+)/\u$1/ if $_ =~ /monkey/' perl_prac.txt

# the if(){} is more reliable if you are using multi statements
perl -ple 'if (/monkey/) { s/(\w+)/\l$1/g; s/(\s)+/ /g; s/(\w+)/\u$1/ }' perl_prac.txt

# parse osrs kill loots from lines that look like, 1. 30k; 2. -30.3k
cat osrskills.txt | cat osrskills.txt | perl -nle 'BEGIN{$total=0}; if(/^\d+.\s(-?.?\d+)k/){ print $1; $total+=$1}; END {print "Total loot is: ", $total}'
# same as above but better. makes use of regex vars
cat osrskills.txt | perl -nle 'BEGIN{$total=0;$x=qr/[+-]?\d*.?\d+/;$regex=qr/\s*\d+.\s*($x)k.*?/}; $total += $1 if m/$regex/; END{print $total}'//same!printf "kill log: rev pking\nDec 2018\n\nRandom notes about the pking trip\n\n1. 445k big money baby\n2. 30k\n3. -30k\n4. died looting\n5. -15.5k\n6. .5k\n7.4k\n\nMore random notes"\n

# how to get around worrying about what your m// delimiter markings are.
# just wrap parts in qr's and feed to the root m//
printf "//\n/\np\n" | perl -nle 'BEGIN{$re=qr-/+-}; print if m/$re/'

# use of Regex::Common lib to find using abstracted regexs from the lib
printf "com.W.tut.C# 9.4934 AAA\ncom.E.tut.java 11.9 DDD\n" | perl -MRegexp::Common -nle 'BEGIN{$re=qr/.?com...\w{3}.\S+ ($RE{num}{real}) .{3}/}s/$re/$1/gi; print'

# REGEX examples END

# HTML examples BEGIN

# get game names regex style
cat bestbuy3ds.txt | perl -nle 'print $1 if m|<h4 class="sku-header">.<a href=.?>(.*)</a></h4>|' | tee bestbuynames.txt

# get prices regex style
cat bestbuy3ds.txt | perl -nle 'print $1 if m|<span aria-label="Your price for this item is .">(.)</span>|' | tee bestbuypricest.txt

# gets game names from the h4 tags with HTML TreeBuilder
cat bestbuy3ds.txt | perl -MHTML::TreeBuilder -le 'my $tree = HTML::TreeBuilder->new_from_content(<>); my @h4s = $tree->look_down(tag => 'h4');print join "\n", map {$->as_text} @h4s'
# same but more in depth, it is same result though
cat bestbuy3ds.txt | perl -MHTML::TreeBuilder -le 'my $tree = HTML::TreeBuilder->new_from_content(<>); my @h4s = $tree->look_down(tag => 'h4'); @e = $tree->look_down("class","sku-header"); print join "\n", map {$->look_down(_tag => "h4")->as_text} @e; $tree->delete'

# grabs the text from the source attribute of every image tag
cat cats.txt | perl -MHTML::TreeBuilder -le 'my $tree = HTML::TreeBuilder->new_from_content(<>); @e = $tree->look_down(tag => 'img'); print join "\n", map {$->attr('src')} @e; $tree->delete'

# NOTE: HTML::TreeBuilder makes use of HTML::Element
#   which has ways of grabing attributes and such

# HTML examples END

# filter eles from one list out of another list
perl -Xsanle 'BEGIN{@xs = split " ", $bads}; print join " ", grep { !($_ ~~ @xs) } @F' -- -bads='Put file hashs here that you dont want to show up. separate them by a space' malshare_shas
# same, but better
perl -MList::Util=any -sanle 'BEGIN{@xs = split " ", $bads}; print join " ", grep { $ele = $; !any { $ eq $ele } @xs } @F' -- -bads='Put file hashs here that you dont want to show up. separate them by a space' malshare_shas
