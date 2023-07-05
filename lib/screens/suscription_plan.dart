import 'package:flutter/material.dart';




class SuscriptionDialog extends StatefulWidget {
  const SuscriptionDialog({super.key});

  @override
  State<SuscriptionDialog> createState() => _SuscriptionDialogState();
}

class _SuscriptionDialogState extends State<SuscriptionDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: ((context) => const HumBurger())));
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Suscription",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Dialog(
        child: Container(
          color: const Color.fromARGB(255, 177, 193, 202),
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/dialog/crown0.png'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      "Rs. 600",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "For 3 months",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
                    )
                  ],
                ),
                const Text(
                  "_________________________________________",
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
                const Text(
                  "We need access to your location to \nbe able to use this service.",
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    subscriptionDialog();
                  },
                  child: const Text("Choose"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  subscriptionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                Container(
                  // height: height(context) * 0.5,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          radius: 60,
                          backgroundImage:
                              const AssetImage('assets/dialog/crown1.png'),
                          child: Stack(
                            children: const [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/dialog/crown0.png'),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "You want to choose",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const Text(
                          "Are you sure you want to \nchoose this premium pack.",
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30))),
                                      builder: ((context) {
                                        return Container(
                                            // height: height(context) * 0.3,
                                            height:300,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(40.0),
                                                    child: Text(
                                                      "STARTER",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30.0),
                                                    child: Row(
                                                      children: const [
                                                        Text(
                                                          "Rs. 600 ",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const Text(
                                                          "For 3 months",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          width:250,
                                                            // width: width(
                                                            //         context) *
                                                            //     0.25,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .lightBlue,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: const Text(
                                                                "BUY NOW"))
                                                      ])
                                                ]));
                                      }));
                                },
                                child: const Text("YES"))),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("NO"))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
