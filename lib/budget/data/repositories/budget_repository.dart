import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_model.dart';

abstract class BudgetRepository {
  Future<List<BudgetModel>> getBudgetsByTrip(String tripId);
  Future<BudgetModel> getBudgetById(String budgetId);
  Future<BudgetModel> createBudget(BudgetModel budget);
  Future<BudgetModel> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String budgetId);
  Future<void> updateSpending(String budgetId, double amount);
  Stream<List<BudgetModel>> watchBudgetsByTrip(String tripId);
  Stream<BudgetModel> watchBudget(String budgetId);
}

class FirestoreBudgetRepository implements BudgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<BudgetModel>> getBudgetsByTrip(String tripId) async {
    try {
      final snapshot = await _firestore
          .collection('budgets')
          .where('tripId', isEqualTo: tripId)
          .orderBy('createdAt')
          .get();

      return snapshot.docs
          .map((doc) => BudgetModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get budgets: $e');
    }
  }

  @override
  Future<BudgetModel> getBudgetById(String budgetId) async {
    try {
      final doc = await _firestore.collection('budgets').doc(budgetId).get();
      
      if (!doc.exists) {
        throw Exception('Budget not found');
      }

      return BudgetModel.fromJson(doc.data()..['id'] = doc.id);
    } catch (e) {
      throw Exception('Failed to get budget: $e');
    }
  }

  @override
  Future<BudgetModel> createBudget(BudgetModel budget) async {
    try {
      final docRef = await _firestore.collection('budgets').add(budget.toJson());
      
      final createdBudget = budget.copyWith(id: docRef.id);
      await docRef.update(createdBudget.toJson());
      
      return createdBudget;
    } catch (e) {
      throw Exception('Failed to create budget: $e');
    }
  }

  @override
  Future<BudgetModel> updateBudget(BudgetModel budget) async {
    try {
      await _firestore.collection('budgets').doc(budget.id).update(budget.toJson());
      return budget;
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _firestore.collection('budgets').doc(budgetId).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  @override
  Future<void> updateSpending(String budgetId, double amount) async {
    try {
      await _firestore.collection('budgets').doc(budgetId).update({
        'spentAmount': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update spending: $e');
    }
  }

  @override
  Stream<List<BudgetModel>> watchBudgetsByTrip(String tripId) {
    return _firestore
        .collection('budgets')
        .where('tripId', isEqualTo: tripId)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }

  @override
  Stream<BudgetModel> watchBudget(String budgetId) {
    return _firestore
        .collection('budgets')
        .doc(budgetId)
        .snapshots()
        .map((doc) => BudgetModel.fromJson(doc.data()!..['id'] = doc.id));
  }
}
