<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entidade.Administrador" %>
<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" href="#">
        <title>Cadastro de Administrador</title>
        <link href="http://localhost:8080/aplicacaoMVC/views/bootstrap/bootstrap.min.css"  rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <jsp:include page="../../comum/menu.jsp" />
            <div class="col-sm-6 offset-3 mt-5">
                <% Administrador Administrador = new Administrador();
                    String acao = (String) request.getAttribute("acao"); 
                    switch(acao) { 
                        case "Incluir": 
                            out.println("<h1>Incluir Administrador</h1>"); 
                            break; 
                        case "Alterar":
                            Administrador = (Administrador) request.getAttribute("admin");
                            out.println("<h1>Alterar Administrador</h1>");
                            break; 
                    }; 
                    String msgError = (String) request.getAttribute("msgError"); 
                    if ((msgError != null) && (!msgError.isEmpty())) {
                    %>
                    <div class="alert alert-danger" role="alert">
                    <%=msgError
                    %>
                    </div>
                    <% }%>
                <form action="/aplicacaoMVC/admin/AdministradorController" method="POST">
                    <input
                            type="hidden"
                            name="id"
                            value="<%=Administrador.getId()%>"
                            class="form-control"
                    />
                    <div class="mb-3">
                        <label for="nome" class="form-label">Nome</label>
                        <input value="<%=Administrador.getNome()%>" type="text" name="nome" class="form-control" placeholder="Nome do administrador" required>
                    </div>
                    <div class="mb-3">
                        <label for="cpf" class="form-label">CPF</label>
                        <input pattern="\d{3}\.\d{3}\.\d{3}-\d{2}" value="<%=Administrador.getCpf()%>" type="text" name="cpf" class="form-control" placeholder="999.999.999-99" required>
                    </div>
                    <div class="mb-3">
                        <label for="senha" class="form-label">Senha</label>
                        <input value="<%=Administrador.getSenha()%>" type="password" name="senha" class="form-control" placeholder="Senha do administrador" required>
                    </div>
                    <div class="mb-3">
                        <label for="endereco" class="form-label">Endereço</label>
                        <input value="<%=Administrador.getEndereco()%>" type="text" name="endereco" class="form-control" placeholder="Endereço" required>
                    </div>
                    <div class="mb-3">
                        <label for="aprovado" class="form-label">Aprovado</label>
                        <select name="aprovado" class="form-control" required>
                            <option <%=Administrador.getAprovado().equals("S") ? "selected" : ""%> value="S">Sim</option>
                            <option <%=Administrador.getAprovado().equals("N") ? "selected" : ""%> value="N">Não</option>
                        </select>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <input value="<%=acao%>" type="submit" name="btEnviar" class="btn btn-primary">
                        </div>
                        <div class="col-sm-2">
                            <a href="/aplicacaoMVC/admin/AdministradorController?acao=Listar" class="btn btn-danger">Retornar</a>
                        </div>
                    </div>
                </form>

            </div>
        </div>
        <script src="views/bootstrap/bootstrap.bundle.min.js"></script>
        <script>
        
        

        function validarCPF(cpf) {
            cpf = cpf.replace(/[^\d]+/g, ''); // Remove qualquer caractere não numérico

            if (cpf.length !== 11) return false; // O CPF deve ter 11 dígitos

            // Validação de CPF
            let soma = 0;
            let resto;

            for (let i = 1; i <= 9; i++) soma += parseInt(cpf.charAt(i - 1)) * (11 - i);
            resto = (soma * 10) % 11;
            if ((resto === 10 || resto === 11) ? parseInt(cpf.charAt(9)) !== 0 : parseInt(cpf.charAt(9)) !== resto) return false;

            soma = 0;
            for (let i = 1; i <= 10; i++) soma += parseInt(cpf.charAt(i - 1)) * (12 - i);
            resto = (soma * 10) % 11;
            if ((resto === 10 || resto === 11) ? parseInt(cpf.charAt(10)) !== 0 : parseInt(cpf.charAt(10)) !== resto) return false;

            return true;
          }

          

          // Função de validação do formulário
          document.getElementById("formulario").addEventListener("submit", function(event) {
            let isValid = true;

            // Obtém todos os campos do formulário
            const nome = document.querySelector("[name='nome']").value;
            const email = document.querySelector("[name='email']").value;
            const celular = document.querySelector("[name='celular']").value;
            const cpf = document.querySelector("[name='cpf']").value;
            const senha = document.querySelector("[name='senha']").value;
            const endereco = document.querySelector("[name='endereco']").value;
            const cidade = document.querySelector("[name='cidade']").value;
            const bairro = document.querySelector("[name='bairro']").value;
            const cep = document.querySelector("[name='aprovado']").value;

            // Verificação de campos vazios
            if (!nome || !email || !celular || !cpf || !senha || !endereco || !cidade || !bairro || !cep) {
              alert("Por favor, preencha todos os campos.");
              isValid = false;
            }

            // Validação do CPF
            if (!validarCPF(cpf)) {
              alert("CPF inválido.");
              isValid = false;
            }

           

            // Se houver algum erro, impede o envio do formulário
            if (!isValid) {
              event.preventDefault();
            }
          });
        
        
        </script>
    </body>
</html>
