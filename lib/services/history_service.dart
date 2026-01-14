import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryService {
  // Absolute path for "Learning Mode" on Windows
  // Note: Only works on Windows/Mac/Linux. Does not work on Web.
  static const String _localPath = r'c:\Users\HP\OneDrive\Desktop\Flutter\qr_generator_and_scanner\history.json';
  
  static const String _storageKey = 'history_list';
  static final HistoryService _instance = HistoryService._internal();

  factory HistoryService() {
    return _instance;
  }

  HistoryService._internal();

  Future<List<HistoryItem>> getHistory() async {
    try {
      if (!kIsWeb) {
         // Desktop Mode: Read from local JSON file
         final file = File(_localPath);
         if (!await file.exists()) {
           return [];
         }
         final content = await file.readAsString();
         // If file is empty, return empty list
         if (content.trim().isEmpty) return [];
         
         final List<dynamic> jsonList = json.decode(content);
         return jsonList.map((e) => HistoryItem.fromJson(e)).toList().reversed.toList();
      } else {
        // Web Mode: Use SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final String? jsonString = prefs.getString(_storageKey);
        
        if (jsonString == null) {
          return [];
        }

        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((e) => HistoryItem.fromJson(e)).toList().reversed.toList();
      }
    } catch (e) {
      print('Error reading history: $e');
      return [];
    }
  }

  Future<void> addToHistory(HistoryItem item) async {
    try {
       if (!kIsWeb) {
          // Desktop Mode: Write to local JSON file
          final file = File(_localPath);
          List<HistoryItem> currentHistory = [];
          
          if (await file.exists()) {
            final content = await file.readAsString();
            if (content.trim().isNotEmpty) {
              final List<dynamic> jsonList = json.decode(content);
              currentHistory = jsonList.map((e) => HistoryItem.fromJson(e)).toList();
            }
          }
          
          currentHistory.add(item);
          // Pretty print JSON for readability
          final encoder = JsonEncoder.withIndent('  ');
          final String prettyJson = encoder.convert(currentHistory.map((e) => e.toJson()).toList());
          
          await file.writeAsString(prettyJson, mode: FileMode.write);
          print('Saved to $_localPath');
       } else {
          // Web Mode
          final prefs = await SharedPreferences.getInstance();
          
          List<HistoryItem> currentHistory = [];
          final String? jsonString = prefs.getString(_storageKey);
          
          if (jsonString != null) {
             final List<dynamic> jsonList = json.decode(jsonString);
             currentHistory = jsonList.map((e) => HistoryItem.fromJson(e)).toList();
          }

          currentHistory.add(item);
          final String newJsonString = json.encode(
            currentHistory.map((e) => e.toJson()).toList()
          );
          
          await prefs.setString(_storageKey, newJsonString);
       }
    } catch (e) {
      print('Error saving history: $e');
    }
  }

  Future<String> getHistoryJsonString() async {
     try {
       List<HistoryItem> items = await getHistory();
       // Re-reverse to original order (oldest first) or keep newest first? 
       // Usually export is better chronological or just raw list.
       // Let's export exactly what is stored (newest last) or just the list.
       // getHistory returns newest first. Let's keep it that way.
       
       final encoder = JsonEncoder.withIndent('  ');
       return encoder.convert(items.map((e) => e.toJson()).toList());
     } catch (e) {
       return '[]';
     }
  }

  Future<void> clearHistory() async {
     try {
       if (!kIsWeb) {
          final file = File(_localPath);
          if (await file.exists()) {
            await file.delete();
          }
       } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_storageKey);
       }
     } catch (e) {
       print('Error clearing history: $e');
     }
  }
}
