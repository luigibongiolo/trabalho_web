package controller;

import entidade.Administrador;
import entidade.Aluno;
import entidade.Professor;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.AdministradorDAO;
import model.AlunoDAO;
import model.ProfessorDAO;
import model.Login;

@WebServlet(name = "AutenticaController", urlPatterns = {"/AutenticaController"})
public class AutenticaController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher rd;
        rd = request.getRequestDispatcher("/views/autenticacao/formLogin.jsp");
        rd.forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher rd;
        // pegando os parâmetros do request
        String cpf_user = request.getParameter("cpf");
        String senha_user = request.getParameter("senha");
        if (cpf_user.isEmpty() || senha_user.isEmpty()) {
            // dados não foram preenchidos retorna ao formulário
            request.setAttribute("msgError", "Usuário e/ou senha incorreto");
            rd = request.getRequestDispatcher("/views/autenticacao/formLogin.jsp");
            rd.forward(request, response);

        } else {
            Login login = new Login();
            if(login.ExisteAdm(cpf_user, senha_user)){
                
                Administrador administradorObtido;
                Administrador administrador = new Administrador(cpf_user, senha_user);
                AdministradorDAO AdministradorDAO = new AdministradorDAO();
                try {
                    administradorObtido = AdministradorDAO.Logar(administrador);
                } catch (Exception ex) {
                    System.out.println(ex.getMessage());
                    throw new RuntimeException("Falha na query para Logar");
                }

                if (administradorObtido.getId() != 0) {
                    if(!administradorObtido.getAprovado().toLowerCase().equals("s")){
                        request.setAttribute("msgError", "Usuário não aprovado");
                        rd = request.getRequestDispatcher("/views/autenticacao/formLogin.jsp");
                        rd.forward(request, response);
                    }else{
                        HttpSession session = request.getSession();
                        session.setAttribute("administrador", administradorObtido);

                        rd = request.getRequestDispatcher("/admin/dashboard");
                        rd.forward(request, response);
                    }

                }
            }
            
            else{
                if(login.ExisteAluno(cpf_user, senha_user)){
                    Aluno alunoObtido;
                    Aluno aluno = new Aluno(cpf_user, senha_user);
                    AlunoDAO alunoDao =  new AlunoDAO();

                    try {
                        alunoObtido = alunoDao.Logar(aluno);
                        HttpSession session = request.getSession();
                        session.setAttribute("alunoLogado", alunoObtido);

                        rd = request.getRequestDispatcher("/aluno/dashboard");
                        rd.forward(request, response);
                    } catch (Exception ex) {
                        System.out.println(ex.getMessage());
                        throw new RuntimeException("Falha na query para Logar");
                    }
                
                
                } else{
                    if(login.ExisteProfessor(cpf_user, senha_user)){
                        Professor professorObtido;
                        Professor professor = new Professor(cpf_user, senha_user);
                        ProfessorDAO professorDAO = new ProfessorDAO();
                        try {
                            professorObtido = professorDAO.Logar(professor);
                            HttpSession session = request.getSession();
                            session.setAttribute("professorLogado", professorObtido);

                            rd = request.getRequestDispatcher("/professor/dashboard");
                            rd.forward(request, response);
                        } catch (Exception ex) {
                            System.out.println(ex.getMessage());
                            throw new RuntimeException("Falha na query para Logar");
                        }
                    }
                    else {
                        request.setAttribute("msgError", "Usuário e/ou senha incorreto");
                        rd = request.getRequestDispatcher("/views/autenticacao/formLogin.jsp");
                        rd.forward(request, response);

                    }
                
                }
                
           }
        }
    }

}
