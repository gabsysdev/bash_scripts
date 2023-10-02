#Gets AWS Token (Cognito) from an Apigee Policy
#Saves the full response from the sent curl command in the file "token.fullResponse"
#Saves the "AccessToken" argument from the response as the file "token.accessToken"
RESPONSE=$(curl --location 'https://cognito-idp.us-east-1.amazonaws.com/' \
--header 'X-Amz-Target: AWSCognitoIdentityProviderService.InitiateAuth' \
--header 'Content-Type: application/x-amz-json-1.1' \
--data '{
   "AuthParameters" : {
      "USERNAME" : "user",
      "PASSWORD" : "password"
   },  
   "AuthFlow" : "USER_PASSWORD_AUTH",
   "ClientId" : "client_id_pass"
}') ; jq '.' <<< $RESPONSE > token.fullResponse; TOKEN=$(echo $RESPONSE | jq '.[] | .AccessToken' | head -1) ; curl -i https://34.160.224.233.nip.io/oauth/token -X POST -H "Authorization: Bearer $TOKEN" ; echo $TOKEN > token.accessToken
