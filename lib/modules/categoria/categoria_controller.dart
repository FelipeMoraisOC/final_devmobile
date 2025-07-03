import 'package:final_devmobile/database/local/categoria_dao.dart';
import 'package:final_devmobile/models/categoria_model.dart';
import 'package:final_devmobile/shared/widgets/custom_snack_bar.dart';

class CategoriaController {
  Future<Categoria?> createCategoria(context, Categoria categoria) async {
    try {
      return await CategoriaDao.insertCategoria(categoria);
    } on Exception catch (e) {
      CustomSnackBar.show(
        context,
        e.toString().replaceAll('Exception: ', ''),
        fail: true,
      );
      context.pop();
      return null;
    }
  }

  Future<void> updateCategoria(context, Categoria categoria) async {
    try {
      await CategoriaDao.updateCategoriaById(
        categoria.id!,
        categoria.nome,
        categoria.usuarioId,
      );
    } on Exception catch (e) {
      CustomSnackBar.show(
        context,
        e.toString().replaceAll('Exception: ', ''),
        fail: true,
      );
      context.pop();
    }
  }

  Future<void> deleteCategoria(context, int id, int usuarioId) async {
    try {
      await CategoriaDao.deleteCategoriaById(id, usuarioId);
    } on Exception catch (e) {
      CustomSnackBar.show(
        context,
        e.toString().replaceAll('Exception: ', ''),
        fail: true,
      );
      context.pop();
    }
  }
}
