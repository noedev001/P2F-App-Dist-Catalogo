import 'package:distribuidoraeye/api/api_service_busqueda.dart';
import 'package:distribuidoraeye/model/productos.dart';
import 'package:flutter/material.dart';

class ProductoSearchDelegate extends SearchDelegate<Product> {
  @override
  final String searchFieldLabel;
  final List<Product> historial;

  ProductoSearchDelegate(this.searchFieldLabel, this.historial);

  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Theme.of(context).primaryColor,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.grey[300],
          ),
          onPressed: () => this.query = '')
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_sharp,
        color: Colors.grey[300],
      ),
      //onPressed: () => this.close(context, null),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Center(child: Text('No se Encontro ningun Resultado'));
    }

    final productService = new ProductService();

    return FutureBuilder<List>(
      future: productService.getCountryByName(query),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return ListTile(title: Text('No hay nada con ese término'));
        }

        if (snapshot.hasData) {
          // crear la lista

          return _showProduct(snapshot.data);
        } else {
          // Loading
          return Center(child: CircularProgressIndicator(strokeWidth: 4));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showProduct(this.historial);
  }

  Widget _showProduct(List<Product> product) {
    return ListView.builder(
      itemCount: product.length,
      // ignore: missing_return
      itemBuilder: (context, i) {
        final pro = product[i];
        //if (pro != 0) {
        return ListTile(
          leading: Image.network(
            pro.imagen,
            width: 60,
            height: 60,
          ),
          title: Text(pro.nombre),
          subtitle: Text(pro.marca),
          trailing: Text(pro.precio + " Bs"),
          onTap: () {
            this.close(context, pro);
          },
        );
        //}
      },
    );
  }
}
