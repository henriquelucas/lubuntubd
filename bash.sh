#!/bin/bash

# URL da nova logo
LOGO_URL="https://raw.githubusercontent.com/henriquelucas/lubuntubd/main/logo.png"

# Diretório onde a logo será salva
LOGO_DIR="/usr/share/plymouth/themes/lubuntu-logo"
LOGO_FILE="$LOGO_DIR/logo.png"

# Verificar se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
   echo "Este script precisa ser executado como root. Use sudo." 
   exit 1
fi

# Criar o diretório do tema, caso não exista
if [ ! -d "$LOGO_DIR" ]; then
    mkdir -p "$LOGO_DIR"
    echo "Diretório $LOGO_DIR criado."
fi

# Baixar a nova logo
echo "Baixando a nova logo de $LOGO_URL..."
wget -O "$LOGO_FILE" "$LOGO_URL"

if [ $? -ne 0 ]; then
    echo "Erro ao baixar a logo. Verifique a URL."
    exit 1
fi
echo "Logo baixada com sucesso e salva em $LOGO_FILE."

# Alterar o tema do Plymouth para usar a nova logo
echo "Configurando Plymouth para usar a nova logo..."

# Backup do arquivo original de script do Plymouth, se ainda não existir
PLYMOUTH_SCRIPT="/usr/share/plymouth/themes/lubuntu-logo/lubuntu-logo.script"

if [ ! -f "$PLYMOUTH_SCRIPT.bak" ]; then
    cp "$PLYMOUTH_SCRIPT" "$PLYMOUTH_SCRIPT.bak"
    echo "Backup do arquivo original criado."
fi

# Adicionar a linha para usar a nova logo no arquivo do script do Plymouth
cat <<EOL > "$PLYMOUTH_SCRIPT"
[Plymouth Theme]
Name=Lubuntu Logo
Description=Splash screen with custom Lubuntu logo
ModuleName=script

[script]
ImageDir=$LOGO_DIR
Logo=logo.png
EOL

# Atualizar Plymouth para aplicar as mudanças
echo "Atualizando Plymouth..."
update-initramfs -u

echo "Logo de inicialização alterada com sucesso! Reinicie o sistema para ver as mudanças."
