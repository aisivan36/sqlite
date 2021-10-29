// ignore_for_file: lines_longer_than_80_chars

import 'package:moor_flutter/moor_flutter.dart';

part 'moor_db.g.dart';

class MoorRecipe extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text()();
  TextColumn get image => text()();
  TextColumn get url => text()();

  RealColumn get calories => real()();
  RealColumn get totalWeight => real()();
  RealColumn get totalTime => real()();
}

class MoorIngredient extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer()();

  TextColumn get name => text()();
  RealColumn get weight => real()();
}

/// Describe the tables — which you defined above — and DAOs this database will use. You’ll create the DAOs next.
@UseMoor(tables: [MoorRecipe, MoorIngredient], daos: [RecipeDao, IngredientDao])

/// Extend _$RecipeDatabase, which the Moor generator will create. This doesn’t exist yet, but the part command at the top will include it.
class RecipeDatabase extends _$RecipeDatabase {
  RecipeDatabase()

      /// When creating the class, call the super class’s constructor. This use the built-in Moor query executor and passes the pathname of the file. It also sets logging to true.
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'recipes.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [MoorRecipe])
class RecipeDao extends DatabaseAccessor<RecipeDatabase> with _$RecipeDaoMixin {
  final RecipeDatabase db;

  RecipeDao(this.db) : super(db);

  Future<List<MoorRecipeData>> findAllRecipes() => select(moorRecipe).get();

  Stream<List<Recipe>> watchAllRecipes() {
    /// TODO add watch all recipes
  }

  /// Define a more complex query that uses where to fetch recipes by ID.
  Future<List<MoorRecipeData>> findRecipeById(int id) =>
      (select(moorRecipe)..where((tbl) => tbl.id.equals(id))).get();

  /// Use into() and insert() to add a new recipe.
  Future<int> insertRecipe(Insertable<MoorRecipeData> recipe) =>
      into(moorRecipe).insert(recipe);

  /// Deleting requires the table and a where. This function just returns true for those rows you want to delete. Instead of get(), you use go().
  Future deleteRecipe(int id) => Future.value(
      (delete(moorRecipe)..where((tbl) => tbl.id.equals(id))).go());
}

@UseDao(tables: [MoorIngredient])
class IngredientDao extends DatabaseAccessor<RecipeDatabase>
    with _$IngredientDaoMixin {
  final RecipeDatabase db;

  IngredientDao(this.db) : super(db);

  Future<List<MoorIngredientData>> findAllIngredients() =>
      select(moorIngredient).get();

  Stream<List<MoorIngredientData>> watchAllIngredients() =>
      select(moorIngredient).watch();

  Future<List<MoorIngredientData>> findRecipeIngredients(int id) =>
      (select(moorIngredient)..where((tbl) => tbl.recipeId.equals(id))).get();

  Future<int> insertIngredient(Insertable<MoorIngredientData> ingredient) =>
      into(moorIngredient).insert(ingredient);

  Future deleteIngredient(int id) => Future.value(
      (delete(moorIngredient)..where((tbl) => tbl.id.equals(id))).go());
}

// TODO: Add moorRecipeToRecipe here

// TODO: Add MoorRecipeData here

// TODO: Add moorIngredientToIngredient and MoorIngredientCompanion here