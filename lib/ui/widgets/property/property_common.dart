import 'package:flutter/material.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/general_services.dart';

import '../../../blocs/favorites/favorites_bloc.dart';

class FavoriteButton extends StatefulWidget {
  final Property property;
  final Function() onChange;

  const FavoriteButton(this.property, this.onChange) : super();

  @override
  _FavoriteState createState() => _FavoriteState(this.property, this.onChange);
}

class _FavoriteState extends State<FavoriteButton> {
  final Property property;
  final Function() onChange;
  final Color favoriteRed = Color.fromRGBO(255, 96, 134, 1.0);

  _FavoriteState(this.property, this.onChange);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints(maxHeight: 20),
      padding: EdgeInsets.zero,
      splashColor: favoriteRed,
      splashRadius: 2,
      icon: Icon(
        this.property.favorite ? Icons.favorite : Icons.favorite_outline,
        color: this.property.favorite ? favoriteRed : Colors.black,
        size: 20.0,
        semanticLabel: 'Favorite',
      ),
      onPressed: () {
        property.favorite = !property.favorite;
        FavoritesBloc()..add(FavoriteToggleEvent(propertyId: property.id, favorite: property.favorite));
        if (property.favorite) {
          GeneralServices.setFavoritePropertyId(property.id);
        } else {
          GeneralServices.removeFavoritePropertyId(property.id);
        }
        setState(() {
          this.onChange();
        });
      },
    );
  }
}
