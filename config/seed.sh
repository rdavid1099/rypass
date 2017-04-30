#!/bin/bash
if [ ! -d "./tmp" ]; then
  echo "Creating ./tmp/"
  mkdir -p tmp/config
fi

FILES[0]='./tmp/this.csv'
FILES[1]='./tmp/that.csv'
FILES[2]='./tmp/test.csv'
FILES[3]='./tmp/test_account.csv'

touch './tmp/config/encryption.yml'
echo '---' >> './tmp/config/encryption.yml'
echo 'SECRET_KEY: pmeOGGBWkfVoKeLbnkjggDK+KdfwzPOTRVl7dslDtVc=' >> './tmp/config/encryption.yml'

for i in {0..3}
do
  NUMBER=$(($i+1))
  echo "Creating seed file $NUMBER of 4"
  touch ${FILES[$i]}
  echo 'username,password,nonce' >> ${FILES[$i]}
  echo "test@test.com,g+Oxh0nrxtBDEp//W1zjyuS58MdYYmIXnOkB0g==,/rK1qZQCYQTin/TsmKXt2uf14RdroqVO" >> ${FILES[$i]}
  echo "tester@tester.com,Wtt3IOdrSaTwL2Xc742tL+S58MdNcUEFmPUE2bkX,/rK1qZQCYQTin/TsmKXt2uf14RdroqVO" >> ${FILES[$i]}
done
