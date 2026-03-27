import 'package:flutter/material.dart';
import '../models/habito.dart';
import 'habit_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool modoNoturno;
  final VoidCallback aoAlternarTema;

  const HomeScreen({
    super.key,
    required this.modoNoturno,
    required this.aoAlternarTema,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habito> _habitos = [];
  bool _estaCarregando = true;

  @override
  void initState() {
    super.initState();
    _carregarHabitosSimulado();
  }

  Future<void> _carregarHabitosSimulado() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _habitos = []; 
      _estaCarregando = false;
    });
  }

  void _alternarHabito(Habito habito, bool? valor) {
    setState(() {
      habito.concluido = valor ?? false;
    });
  }

  void _mostrarAlertaFlutuante(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _mostrarDialogoCriarHabito() {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (contextoDialogo) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: const Text('Novo Hábito'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título', hintText: 'Ex: Ler 10 páginas'),
                  validator: (v) => v!.isEmpty ? 'Informe o título' : null,
                  autofocus: true,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descrição (Opcional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: const Text('Cancelar', style: TextStyle(color: Colors.blueGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.tealAccent : Colors.teal, 
                foregroundColor: isDark ? Colors.teal : Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _habitos.add(Habito(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      titulo: tituloCtrl.text,
                      descricao: descCtrl.text,
                    ));
                  });
                  Navigator.pop(contextoDialogo);
                  _mostrarAlertaFlutuante('Hábito criado!', Colors.teal);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _abrirDetalhes(Habito habito) async {
    final acao = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailsScreen(habito: habito),
      ),
    );

    if (!mounted) return; 

    if (acao == 'deletar') {
      setState(() {
        _habitos.removeWhere((h) => h.id == habito.id);
      });
      _mostrarAlertaFlutuante('Hábito excluído!', Colors.red);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    int concluidos = _habitos.where((h) => h.concluido).length;
    int total = _habitos.length;
    double progresso = total == 0 ? 0 : concluidos / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Hábitos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.modoNoturno ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.aoAlternarTema,
            tooltip: 'Alternar Tema',
          ),
        ],
      ),
      body: _estaCarregando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text('Preparando seu dia...', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.modoNoturno ? Colors.blueGrey : Colors.teal[50],
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Progresso de Hoje',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.modoNoturno ? Colors.white : Colors.teal[800]),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progresso,
                        backgroundColor: widget.modoNoturno ? Colors.blueGrey[700] : Colors.teal[100],
                        color: Colors.teal,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$concluidos de $total completados',
                        style: TextStyle(fontSize: 16, color: widget.modoNoturno ? Colors.white : Colors.teal[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _habitos.isEmpty 
                      ? const Center(
                          child: Text(
                            'Você ainda não tem hábitos.\nToque em "Novo Hábito" para começar!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _habitos.length,
                          itemBuilder: (context, index) {
                            final habito = _habitos[index];
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: widget.modoNoturno ? Colors.blueGrey[800]! : Colors.blueGrey[200]!),
                              ),
                              color: widget.modoNoturno 
                                  ? (habito.concluido ? Colors.teal.withValues(alpha: 0.3) : Colors.blueGrey)
                                  : (habito.concluido ? Colors.teal[50] : Colors.white),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                title: Text(
                                  habito.titulo,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    decoration: habito.concluido ? TextDecoration.lineThrough : TextDecoration.none,
                                    color: habito.concluido ? Colors.blueGrey : (widget.modoNoturno ? Colors.white : Colors.black87),
                                  ),
                                ),
                                leading: Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: habito.concluido,
                                    onChanged: (valor) => _alternarHabito(habito, valor),
                                    activeColor: Colors.teal,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: widget.modoNoturno ? Colors.blueGrey[600] : Colors.blueGrey[400]),
                                onTap: () => _abrirDetalhes(habito),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogoCriarHabito,
        backgroundColor: widget.modoNoturno ? Colors.blueGrey : Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Hábito', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}