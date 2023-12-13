import 'package:flutter/material.dart';

void main() {
  runApp(VerificarIMC());
}

class VerificarIMC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PessoaListScreen(),
    );
  }
}

class Pessoa {
  final String nome;
  final double? peso;
  final double? altura;
  final double imc;

  Pessoa({
    required this.nome,
    required this.peso,
    required this.altura,
    required this.imc,
  });
}

class PessoaListScreen extends StatefulWidget {
  @override
  _PessoaListScreenState createState() => _PessoaListScreenState();
}

class _PessoaListScreenState extends State<PessoaListScreen> {
  List<Pessoa> _pessoas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pessoas'),
      ),
      body: ListView.builder(
        itemCount: _pessoas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_pessoas[index].nome),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PessoaDetailScreen(pessoa: _pessoas[index]),
                ),
              );
            },
            onLongPress: () {
              // Excluir registro
              _pessoas.removeAt(index);
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PessoaFormScreen(
                onAdicionar: (pessoa) {
                  _pessoas.add(pessoa);
                  setState(() {});
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PessoaFormScreen extends StatefulWidget {
  final Function(Pessoa) onAdicionar;

  const PessoaFormScreen({Key? key, required this.onAdicionar})
      : super(key: key);

  @override
  _PessoaFormScreenState createState() => _PessoaFormScreenState();
}

class _PessoaFormScreenState extends State<PessoaFormScreen> {
  final _form = GlobalKey<FormState>();
  final _valorPeso = TextEditingController();
  final _valorNome = TextEditingController();
  final _valorAltura = TextEditingController();
  String _resultado = "Resultado";
  String _classificacao = "";

  void _calcularIMC() {
    double? peso = double.tryParse(_valorPeso.text);
    double? altura = double.tryParse(_valorAltura.text);

    if (peso != null && altura != null) {
      double imc = peso / (altura * altura);
      setState(() {
        _resultado = "Seu IMC é: ${imc.toStringAsFixed(2)}";

        if (imc <= 18.5) {
          _classificacao = "Classificação: Abaixo do peso";
        } else if (imc >= 18.6 && imc <= 24.9) {
          _classificacao = "Classificação: Peso normal";
        } else if (imc >= 25 && imc <= 29.9) {
          _classificacao = "Classificação: Acima do peso";
        } else if (imc >= 30 && imc <= 39.9) {
          _classificacao = "Obesidade grau 1";
        } else if (imc >= 40) {
          _classificacao = "Obesidade grau 2";
        }
      });
    } else {
      setState(() {
        _resultado = "Informe peso e altura válidos.";
      });
    }
  }

  void _limparCampos() {
    _valorNome.text = "";
    _valorPeso.text = "";
    _valorAltura.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _valorNome,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Insira o seu nome',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorPeso,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Insira o seu peso',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o peso';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorAltura,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Insira a sua altura',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a sua altura';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _calcularIMC();
                    widget.onAdicionar(
                      Pessoa(
                        nome: _valorNome.text,
                        peso: double.tryParse(_valorPeso.text),
                        altura: double.tryParse(_valorAltura.text),
                        imc: double.parse(_resultado.split(' ')[3]),
                      ),
                    );
                    _limparCampos();
                    Navigator.pop(context); // Voltar para a tela anterior
                  }
                },
                child: Text('Adicionar'),
              ),
              Text(_resultado),
              Text(_classificacao),
            ],
          ),
        ),
      ),
    );
  }
}

class PessoaDetailScreen extends StatelessWidget {
  final Pessoa pessoa;

  const PessoaDetailScreen({Key? key, required this.pessoa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nome: ${pessoa.nome}'),
            Text('Peso: ${pessoa.peso} Kg'),
            Text('Altura: ${pessoa.altura} m'),
            Text('IMC: ${pessoa.imc.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
