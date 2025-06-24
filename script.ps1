$pfxPath = "C:\caminho\para\certificado.pfx"
$pfxPassword = ConvertTo-SecureString -String "SENHA_DO_PFX" -Force -AsPlainText
$certStore = "Cert:\LocalMachine\My"

Import-PfxCertificate -FilePath $pfxPath -CertStoreLocation $certStore -Password $pfxPassword
Get-ChildItem -Path Cert:\LocalMachine\My | Select-Object Subject, Thumbprint

$ipPort = "0.0.0.0:443"
$certThumbprint = "THUMBPRINT_DO_CERTIFICADO"  # Copiado do passo anterior
$appId = "{00112233-4455-6677-8899-AABBCCDDEEFF}"  # Pode ser um GUID aleatório

netsh http add sslcert ipport=$ipPort certhash=$certThumbprint appid=$appId

netsh http show sslcert