#!/bin/bash
if [ ! -d "./tmp" ]; then
  echo "Creating ./tmp/"
  mkdir -p tmp
fi

FILES[0]='./tmp/this.csv'
FILES[1]='./tmp/that.csv'
FILES[2]='./tmp/test.csv'
FILES[3]='./tmp/test_account.csv'

for i in {0..3}
do
  NUMBER=$(($i+1))
  echo "Creating seed file $NUMBER of 4"
  touch ${FILES[$i]}
  echo 'username,password' >> ${FILES[$i]}
  echo "test@test.com,testPassword$i" >> ${FILES[$i]}
  echo "tester@tester.com,testerPassword$i" >> ${FILES[$i]}
done
