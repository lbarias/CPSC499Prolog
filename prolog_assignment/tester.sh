# If you want to run it in gprolog and test your own queries, use the following
# gprolog --consult-file families.pl --consult-file family_reasoning.pl

# I will test your code with the following:
javac PrologTest.java
echo "family_reasoning.pl" | java PrologTest > result.txt
