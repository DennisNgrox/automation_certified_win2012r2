#!/usr/bin/expect -f

# Variáveis
set domain "*.teste.com.br"
set timeout -1

# Iniciar o certbot
spawn certbot certonly --manual --preferred-challenges dns -d $domain

# Capturar a frase que contém o nome do registro
expect "Please deploy a DNS TXT record under the name:"

# Capturar o nome do registro
expect {
    -re {\n(.*)\r} {
        set dns_record $expect_out(1,string)
        puts "DNS Record capturado: $dns_record"
    }
}

# Capturar a frase que contém o token
expect "with the following value:"

# Capturar o token
expect {
    -re {\n(.*)\r} {
        set token $expect_out(1,string)
        puts "Token capturado: $token"
    }
}

# Executar o terraform com as variáveis capturadas
puts "Executando Terraform com as variáveis capturadas..."
exec terraform apply -auto-approve -var "acme_record_name=$dns_record" -var "acme_token=$token"

# Aguardar propagação DNS (60 segundos)
sleep 60

# Simular ENTER no certbot
expect "Press Enter to Continue"
send "\r"

# Aguardar o certbot finalizar
expect eof
