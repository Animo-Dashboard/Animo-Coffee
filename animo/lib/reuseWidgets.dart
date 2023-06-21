import 'package:animo/pages/errorHandling_page.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

BoxDecoration getAppBackground() {
  return BoxDecoration(
    image: DecorationImage(
      image: const AssetImage('images/background2.png'),
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
      colorFilter: ColorFilter.mode(
        Colors.white.withOpacity(0.3),
        BlendMode.dstATop,
      ),
    ),
  );
}

BoxDecoration getBackgroundIfError(List<String> errors) {
  if (errors.isNotEmpty) {
    return BoxDecoration(
      color: CustomColors.red.withAlpha(80),
      border: Border.all(
        color: CustomColors.red,
        width: 2.0,
      ),
    );
  } else {
    return const BoxDecoration();
  }
}

StatelessWidget getLeadingIcon(String title, BuildContext context) {
  if (title == "Your devices") {
    return Container(
      padding: EdgeInsets.all(10),
      child: const Image(
        image: AssetImage('images/logoSymbolWhite.png'),
        height: 1,
        width: 1,
      ),
    );
  } else {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      iconSize: 40,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

AppBar getAppBar(BuildContext context, String pageTitle,
    [List<String>? moreMenuOptions, void Function(String value)? handleClick]) {
  if (moreMenuOptions != null) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: getLeadingIcon(pageTitle, context),
      title: Text(
        pageTitle,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: handleClick,
          icon: const Icon(
            Icons.more_horiz_sharp,
            size: 48,
          ),
          padding: const EdgeInsets.only(right: 30),
          itemBuilder: (BuildContext context) {
            return moreMenuOptions.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: handleColorMoreMenuOptions(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  } else {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: getLeadingIcon(pageTitle, context),
      title: Text(
        pageTitle,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
      ),
    );
  }
}

Image getModelImage(String modelName) {
  List<String> modelImageNames = ["touch2", "touch3", "touch4"];
  if (modelImageNames.contains(modelName)) {
    return Image.asset('images/$modelName.png');
  } else {
    String imageName = modelName;
    switch (modelName) {
      case "OptiBean 2 Touch":
        imageName = "touch2";
        break;
      case "OptiBean 3 Touch":
        imageName = "touch3";
        break;
      case "OptiBean 4 Touch":
        imageName = "touch4";
        break;
      default:
        imageName = "touch2";
        break;
    }
    return Image.asset('images/$imageName.png');
  }
}

StreamBuilder<QuerySnapshot> getErrorStreamBuilder(
    CollectionReference machinesCollection,
    String errorType,
    String user,
    String role) {
  return StreamBuilder<QuerySnapshot>(
    stream: machinesCollection.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final machines = snapshot.data?.docs ?? [];

      var userMachines;
      if (role == "admin") {
        userMachines = machines;
      } else {
        userMachines = machines.where((machine) =>
            (machine.data() as Map<String, dynamic>)["User"] == user);
      }

      // Filter machines with new errors
      final machinesWithNewErrors = userMachines
          .where((machine) =>
              (machine.data() as Map<String, dynamic>?)
                  ?.containsKey(errorType) ??
              false)
          .toList();

      if (machinesWithNewErrors.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'No errors found.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: machinesWithNewErrors.length,
        itemBuilder: (context, index) {
          final machine = machinesWithNewErrors[index];

          return ListTile(
            title: Text(
              (machine.data() as Map<String, dynamic>)['Name'] ?? '',
            ),
            subtitle: getSubtitleText(errorType, machine),
            trailing: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                moveToCurrentErrors(machine.id, machinesCollection);
                Navigator.pushNamed(context, '/deviceStatistics',
                    arguments: {"device": machine.data(), "id": machine.id});
              },
            ),
          );
        },
      );
    },
  );
}

getSubtitleText(String errorType, QueryDocumentSnapshot<Object?> machine) {
  switch (errorType) {
    case "Error":
      return Text(
        (machine.data() as Map<String, dynamic>)['Error'] ?? '',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
      );
    case "CurrentError":
      final currentErrors = (machine.data()
          as Map<String, dynamic>)['CurrentError'] as List<dynamic>;
      currentErrors.removeWhere((element) => element == null);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          currentErrors.length,
          (index) => Text(
            currentErrors[index].toString(),
            style:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
          ),
        ),
      );
    default:
      return Text("Whoops");
  }
}

Future<void> moveToCurrentErrors(
    String machineId, CollectionReference machinesCollection) async {
  try {
    // Get the document reference for the machine
    final machineDoc = machinesCollection.doc(machineId);

    // Fetch the current error value
    final machineSnapshot = await machineDoc.get();
    final machineData = machineSnapshot.data() as Map<String, dynamic>?;

    if (machineData != null) {
      final currentErrors = machineData['CurrentError'] ?? [];
      final error = machineData['Error'];

      // Update the document to move the machine to current errors list
      await machineDoc.update({
        'CurrentError': FieldValue.arrayUnion([error]),
        'Error': FieldValue.delete(),
      });
    }
  } catch (error) {
    print('Error moving machine to current errors: $error');
  }
}
