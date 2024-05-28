set -e

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then
    echo 'Correct file exists'
else
    exit
fi


cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java

if [[ $? -eq 0 ]]
then    
    echo "Java files compiled successfully"
else
    echo "Compilation error, please double check your ListExamples.java file"
    exit
fi

java -cp "$CPATH" org.junit.runner.JUnitCore TestListExamples > grade.txt
grep "Failures" grade.txt > checkfail.txt

if [[ -s "checkfail.txt" ]]
then
total=`cut -d':' -f2 checkfail.txt | cut -d',' -f1 | cut -d' '-f2`
echo "Total is $total"
totalint=$(($total))

failcount=`cut -d',' -f2 checkfail.txt | cut -d':' -f2 | cut -d' ' -f2`
echo "Failcount is $failcount"

failcountint=$(($failcount))
score=$(($totalint-$failcountint))

echo "Score is $score"
echo "Your score is $score/$totalint"
else
echo "You passed with 100%!"
fi