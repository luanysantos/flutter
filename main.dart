import 'package:flutter/material.dart'; // Importa o pacote Flutter Material Design para construir a interface do usuário.
import 'package:shared_preferences/shared_preferences.dart'; // Importa o pacote SharedPreferences para armazenar dados localmente.

void main() {
  runApp(
    const TarefaApp(),
  ); // Inicia o aplicativo com a classe TarefaApp como widget principal.
}

class TarefaApp extends StatelessWidget {
  const TarefaApp({
    super.key,
  }); // A classe TarefaApp é Stateless porque não muda de estado.

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaTarefa(), // A tela principal do aplicativo será TelaTarefa.
    );
  }
}

class TelaTarefa extends StatefulWidget {
  const TelaTarefa({
    super.key,
  }); // TelaTarefa é StatefulWidget porque a lista de tarefas muda dinamicamente.

  @override
  State<TelaTarefa> createState() => _TelaTarefaState(); // Criação do estado da TelaTarefa.
}

class _TelaTarefaState extends State<TelaTarefa> {
  final TextEditingController tarefaController =
      TextEditingController(); // Controlador do campo de texto para digitar novas tarefas.
  List<String> tarefas = []; // Lista para armazenar as tarefas.

  @override
  void initState() {
    super.initState();
    _carregarTarefas(); // Carrega as tarefas armazenadas no SharedPreferences ao iniciar a tela.
  }

  // Função que carrega as tarefas salvas no SharedPreferences.
  void _carregarTarefas() async {
    final prefs =
        await SharedPreferences.getInstance(); // Obtém a instância do SharedPreferences.
    setState(() {
      tarefas =
          prefs.getStringList('tarefas') ??
          []; // Carrega as tarefas ou retorna uma lista vazia se não houver tarefas salvas.
    });
  }

  // Função para salvar as tarefas no SharedPreferences.
  void salvarTarefas() async {
    final prefs =
        await SharedPreferences.getInstance(); // Obtém a instância do SharedPreferences.
    prefs.setStringList('tarefas', tarefas); // Salva a lista de tarefas.
  }

  // Função para adicionar uma nova tarefa à lista.
  void adicionarTarefa() {
    setState(() {
      final novaTarefa =
          tarefaController.text; // Obtém o texto digitado no campo de texto.
      if (novaTarefa.isNotEmpty) {
        tarefas.add(novaTarefa); // Adiciona a nova tarefa à lista.
        tarefaController
            .clear(); // Limpa o campo de texto após adicionar a tarefa.
        salvarTarefas(); // Salva a lista de tarefas atualizada no SharedPreferences.
      }
    });
  }

  // Função para remover uma tarefa da lista.
  void removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index); // Remove a tarefa no índice fornecido.
      salvarTarefas(); // Salva as tarefas atualizadas no SharedPreferences.
    });
  }

  // Função para editar uma tarefa existente.
  void editarTarefa(int index) {
    TextEditingController editController = TextEditingController(
      text:
          tarefas[index], // Inicializa o controlador com o texto da tarefa que será editada.
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Editar Tarefa',
          ), // Título da caixa de diálogo para edição.
          content: TextField(
            controller: editController, // Controlador para editar a tarefa.
            decoration: const InputDecoration(
              labelText: 'Tarefa',
            ), // Rótulo do campo de edição.
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'), // Botão para cancelar a edição.
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(); // Fecha a caixa de diálogo sem salvar alterações.
              },
            ),
            TextButton(
              child: const Text(
                'Salvar',
              ), // Botão para salvar a tarefa editada.
              onPressed: () {
                setState(() {
                  tarefas[index] =
                      editController
                          .text; // Atualiza a tarefa com o novo texto.
                });
                salvarTarefas(); // Salva as tarefas atualizadas no SharedPreferences.
                Navigator.of(
                  context,
                ).pop(); // Fecha a caixa de diálogo após salvar.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        // Cor de fundo da tela.
        255,
        1,
        55,
        216,
      ),
      // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      appBar: AppBar(
        title: const Text('Lista de Tarefas'), // Título da barra superior.
        backgroundColor: const Color.fromARGB(
          255,
          84,
          130,
          255,
        ), // Cor de fundo da AppBar.
      ),
      body: ListView.builder(
        itemCount: tarefas.length, // Número de itens (tarefas) na lista.
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white, // Cor de fundo do cartão da tarefa.
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ), // Margens para os cartões.
            child: ListTile(
              title: Text(
                tarefas[index], // Exibe o texto da tarefa.
                style: const TextStyle(
                  fontSize: 18,
                ), // Estilo do texto da tarefa.
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ), // Adiciona espaçamento entre o ícone e o topo da célula.
                child: Row(
                  mainAxisSize:
                      MainAxisSize
                          .min, // Coloca os ícones na parte direita da tela.
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                      ), // Ícone para editar a tarefa.
                      color: const Color.fromARGB(
                        255,
                        49,
                        48,
                        48,
                      ), // Cor do ícone de edição.
                      onPressed:
                          () => editarTarefa(
                            index,
                          ), // Chama a função para editar a tarefa.
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                      ), // Ícone para excluir a tarefa.
                      color: Colors.red, // Cor do ícone de exclusão.
                      onPressed:
                          () => removerTarefa(
                            index,
                          ), // Chama a função para remover a tarefa.
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(
          255,
          110,
          161,
          255,
        ), // Cor do botão flutuante.
        shape: const CircleBorder(), // Torna o botão redondo.
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Adicionar Tarefa',
                ), // Título da caixa de diálogo para adicionar tarefa.
                content: TextField(
                  controller:
                      tarefaController, // Controlador do campo de texto para nova tarefa.
                  decoration: const InputDecoration(
                    labelText: 'Tarefa',
                  ), // Rótulo do campo de entrada.
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'Cancelar',
                    ), // Botão para cancelar a adição de tarefa.
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop(); // Fecha a caixa de diálogo sem adicionar a tarefa.
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Adicionar',
                    ), // Botão para adicionar a nova tarefa.
                    onPressed: () {
                      adicionarTarefa(); // Chama a função para adicionar a tarefa.
                      Navigator.of(
                        context,
                      ).pop(); // Fecha a caixa de diálogo após adicionar a tarefa.
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // Ícone de adição no botão flutuante.
      ),
    );
  }
}
