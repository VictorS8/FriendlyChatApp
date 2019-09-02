import 'package:flutter/material.dart';

const String _name = 'Jota';

void main() {runApp(FriendlyChat());}

class FriendlyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.purple[700],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController(); // Criando um controlador de texto privado
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;
  // Verificar quando o usuario modificar
  void _handleSubmitted(String text) {
    _textController.clear(); // Apenas apagando o campo de texto
    setState(() {
     _isComposing = false; 
    });
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        vsync: this, // Para não gastar memoria em algo fora da tela
        duration: Duration(seconds: 2), // Duração da animação
      ),
    );
    setState(() {
     _messages.insert(0, message); 
    });
    message.animationController.forward(); // Controle para a posição da animação
  }
  // Boa pratica colocar o dispose() para liberar os espaços de uso quando não for mais preciso
  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FriendlyChat'),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemExtent: 50,
              reverse: true, // Começar do final da tela
              itemBuilder: (_, int index) => _messages[index], // (_,) é uma convenção para dizer que não será usado
              itemCount: _messages.length, // Dizer o numero da mensagem na lista (messages on List)
            ),
          ),
          Divider(height: 5), // Linha imaginaria entre os widgets
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
  // Criando um Widget de ler texto no TextField
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData( // Sera usado a cor passada pelo Widget no Material App do FriendlyChat 
        color: Theme.of(context).accentColor,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Flexible( // Criando um campo na tela flexivel
              child: TextField(
                controller: _textController, // Controle
                onSubmitted: _handleSubmitted, // Na mudança
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message', 
                ),
                onChanged: (String text) {
                  setState(() {
                   _isComposing = text.length > 0; 
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null, // No clique ele limpa o controlador (_textController.text) pela mudança no (_handleSubmitted)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      alwaysIncludeSemantics: true,
      opacity: animationController,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Organizar os widget em relação aos pais (Row)
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                child: Text(
                  _name[0],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.purple[700],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Organizar os widget em relação aos pais (Column)
                children: <Widget>[
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}