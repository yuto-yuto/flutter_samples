import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableSample extends StatefulWidget {
  @override
  _DraggableSample createState() => _DraggableSample();
}

class DraggableFood {
  String value;
  Widget widget;
  DraggableFood({
    required this.value,
    required this.widget,
  });
}

class _DraggableSample extends State<DraggableSample> {
  int eggCount = 0;
  int baconCount = 0;
  int milkCount = 0;

  @override
  Widget build(BuildContext context) {
    final egg = _createFood("Egg");
    final bacon = _createFood("Bacon");
    final milk = _createFood("Milk");
    final baconEggGroup = _createExpansionTile("baconEgg", [egg, bacon, milk]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Draggable sample"),
        ),
        body: Column(
          children: [
            _createDraggable(context, baconEggGroup),
            _createDragTarget(context),
          ],
        ),
      ),
    );
  }

  DraggableFood _createExpansionTile(
      String groupName, List<DraggableFood> foods) {
    final widgets = foods.map((e) => _createDraggable(context, e)).toList();

    final expansionTile = ExpansionTile(
      title: Text(groupName),
      children: widgets,
    );

    return DraggableFood(
      value: foods.map((e) => e.value).join(","),
      widget: expansionTile,
    );
  }

  DraggableFood _createFood(String name) {
    final listTile = ListTile(
      leading: Icon(Icons.food_bank),
      title: Text(name),
    );
    return DraggableFood(
      value: name,
      widget: Card(child: listTile),
    );
  }

  Widget _createDraggable(BuildContext context, DraggableFood data) {
    // not work
    // final feedback = ListTile(
    //   leading: const Icon(Icons.directions_run),
    //   title: Text("Food"),
    // );

    final feedback = Material(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: ListTile(
          leading: const Icon(Icons.directions_run),
          title: Text(data.value),
        ),
      ),
    );

    return Draggable(
      data: data.value,
      child: data.widget,
      feedback: feedback,
    );
  }

  Border border = Border.all(color: Colors.black, width: 5);
  Widget _createDragTarget(BuildContext context) {
    return DragTarget<String>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        final text = 'Egg: $eggCount\n'
            'Bacon: $baconCount\n'
            'Milk: $milkCount\n';

        return Container(
          margin: EdgeInsets.only(top: 100),
          height: 100,
          width: 200,
          child: Text(text),
          decoration: BoxDecoration(
            border: border,
            color: Colors.blue.shade50,
          ),
        );
      },
      onMove: (details) {
        setState(() {
          border = _setBorder(Colors.red);
        });
      },
      onAccept: (data) {
        setState(() {
          eggCount += data.contains("Egg") ? 1 : 0;
          milkCount += data.contains("Milk") ? 1 : 0;
          baconCount += data.contains("Bacon") ? 1 : 0;
          border = _setBorder(Colors.black);
        });
      },
    );
  }

  Border _setBorder(Color color) => Border.all(color: color, width: 5);
}
