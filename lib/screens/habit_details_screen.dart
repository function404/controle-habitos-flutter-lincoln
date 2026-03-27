import 'package:flutter/material.dart';
import '../models/habito.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habito habito;

  const HabitDetailsScreen({super.key, required this.habito});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {

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

  void _mostrarDialogoEditar() {
    final tituloCtrl = TextEditingController(text: widget.habito.titulo);
    final descCtrl = TextEditingController(text: widget.habito.descricao);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (contextoDialogo) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          title: const Text('Editar Hábito'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) => v!.isEmpty ? 'Informe o título' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descrição'),
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
                    widget.habito.titulo = tituloCtrl.text;
                    widget.habito.descricao = descCtrl.text;
                  });
                  Navigator.pop(contextoDialogo);
                  _mostrarAlertaFlutuante('Hábito atualizado!', Colors.teal);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Excluir Hábito'),
          content: Text('Deseja realmente excluir "${widget.habito.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: const Text('Cancelar', style: TextStyle(color: Colors.blueGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(contextoDialogo);
                Navigator.pop(context, 'deletar');
              },
              child: const Text('Sim, Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Hábito'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _mostrarDialogoEditar,
            tooltip: 'Editar Hábito',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _confirmarExclusao,
            tooltip: 'Excluir Hábito',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              widget.habito.concluido ? Icons.task_alt : Icons.hourglass_empty,
              size: 80,
              color: widget.habito.concluido ? Colors.teal : Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              widget.habito.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: widget.habito.concluido 
                    ? (isDark ? Colors.teal.withValues(alpha: 0.4) : Colors.teal[100])
                    : (isDark ? Colors.orange.withValues(alpha: 0.4) : Colors.orange[100]),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: widget.habito.concluido ? Colors.teal : Colors.orange,
                  width: 1.5,
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.habito.concluido ? Icons.check_circle : Icons.pending,
                    color: widget.habito.concluido ? Colors.teal : Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.habito.concluido ? 'Hábito Concluído!' : 'Pendente para hoje.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.habito.concluido 
                          ? (isDark ? Colors.tealAccent : Colors.teal[800]) 
                          : (isDark ? Colors.orangeAccent : Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Sobre este hábito',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.blueGrey : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.habito.descricao.isNotEmpty ? widget.habito.descricao : 'Nenhuma descrição adicionada.',
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}