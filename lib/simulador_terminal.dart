import 'dart:io';
import 'models/administrador.dart';
import 'models/cliente.dart';
import 'models/usuario.dart';

void main() {
  List <Usuario> usuariosCadastrados = [];
  bool sistemaRodando = true;

  print('--- BEM-VINDO AO SIMULADOR DE OBJETOS COMA BEM');
  
  while(sistemaRodando) {
    print('\nSelecione uma ação: ');
    print('1 - Cadastrar novo Cliente');
    print('2 - Cadastrar novo Administrador');
    print('3 - Listar perfis e exibir Menus');
    print('4 - Sair');
    
    stdout.write('Sua opção: ');
    String? opcao = stdin.readLineSync();

    switch(opcao) {
      case '1':
        stdout.write('Escreva o nome do Cliente: ');
        String? nome = stdin.readLineSync();
        var clienteNovo = new Cliente(0, nome.toString(), '$nome@email.com', "$nome!senha");
        usuariosCadastrados.add(clienteNovo);
        if (usuariosCadastrados.contains(clienteNovo)) {
          stdout.write('Cliente $nome cadastrado com sucesso');
        } else {
          stdout.write('Não foi possível cadastrar. Tente novamente mais tarde...');
        }
        break;
      case '2':
        stdout.write('Escreva o nome do Administradot: ');
        String? nome = stdin.readLineSync();
        var admNovo = new Administrador(0, nome.toString(), '$nome@email.com', "$nome!senha");
        usuariosCadastrados.add(admNovo);
        if (usuariosCadastrados.contains(admNovo)) {
          stdout.write('Admin $nome cadastrado com sucesso');
        } else {
          stdout.write('Não foi possível cadastrar. Tente novamente mais tarde...');
        }
        break;
      case '3':
        if (usuariosCadastrados.isEmpty) {
          stdout.write('Não há nenhum usuário na lista.');
        } else {
          for (int i = 0; i < usuariosCadastrados.length; i++) {
            Usuario userAtual = usuariosCadastrados[i];
            print(userAtual.nomeUsuario);
            userAtual.exibirMenu();
          }
        }
        break;
      case '4':
        print('\nEncerrando aplicação...');
        sistemaRodando = false;
        break;
      default:
        print('Opcao inválida! Digite um valor de 1 a 4');
    }
  }
}