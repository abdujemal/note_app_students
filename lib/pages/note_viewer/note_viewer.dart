import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:note_app_students/Firebase%20Services/user_service.dart';
import 'package:note_app_students/constants/values.dart';
import 'package:note_app_students/model/note.dart';
import 'package:note_app_students/pages/note_viewer/controller/pdf_viewer_controller.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:performance/performance.dart';

class NoteViewer extends StatefulWidget {
  Note note;
  NoteViewer({Key? key, required this.note}) : super(key: key);

  @override
  _NoteViewerState createState() => _NoteViewerState();
}

class _NoteViewerState extends State<NoteViewer> {
  PVController pvController = Get.put(PVController());
  Directory appDocDir = Directory("");

  int _allPagesCount = 0;

  int _actualPageNumber = 1;

  int initialPage = 1;

  TextEditingController _pageTC = TextEditingController();

  @override
  void initState() {
    Get.lazyPut(() => UserService());
    // TODO: implement initState
    super.initState();
    pvController.setFilePath("");

    checkTheFileExists();
  }

  checkTheFileExists() async {
    String nid = widget.note.nid;
    appDocDir = await getApplicationDocumentsDirectory();
    if (await File('${appDocDir.path}/${nid}.pdf').exists()) {
      print("${appDocDir.path}/${nid}.pdf");
      pvController.setFilePath("${appDocDir.path}/${nid}.pdf");
      pvController.setPdfController(PdfControllerPinch(
          initialPage: initialPage,
          document:
              PdfDocument.openFile("${appDocDir.path}/${widget.note.nid}.pdf"),),);
    } else {
      pvController.setFilePath("");
      await Get.find<UserService>().downloadPDF(nid);
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   pdfController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.note.title),
        ),
        body: Obx(() {
          if (pvController.filePath.value == "") {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: CircularProgressIndicator(
                  color: mainColor,
                )),
                const SizedBox(
                  height: 15,
                ),
                const Text("Downloading...")
              ],
            ));
          } else {
            
            return Column(
              children: [
                Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15.0),
                            child: TextField(
                              controller: _pageTC,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(hintText: "Page number"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (double.parse(_pageTC.text).round() <= 0) {
                              pvController.pdfController.value.goToPage(pageNumber: 1);
                            } else if (double.parse(_pageTC.text).round() >
                                _allPagesCount) {
                              pvController.pdfController.value.goToPage(
                                  pageNumber: _allPagesCount);
                            } else {
                              pvController.pdfController.value.goToPage(
                                  pageNumber:
                                      double.parse(_pageTC.text).round());
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(color: mainColor,),
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: const Text("Go",style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    )),
                Flexible(
                  flex: 9,
                  child: PdfViewPinch(
                    documentLoader:
                        const Center(child: CircularProgressIndicator()),
                    pageLoader:
                        const Center(child: CircularProgressIndicator()),
                    controller: pvController.pdfController.value,
                    onDocumentLoaded: (document) {
                      setState(() {
                        _allPagesCount = document.pagesCount;
                      });
                    },
                    onPageChanged: (page) {
                      setState(() {
                        _actualPageNumber = page;
                      });
                    },
                  ),
                ),
              ],
            );
          }
        }));
  }
}
