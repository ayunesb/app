import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paradigm_mex/blocs/filters/filters_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/amenitites_service.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/service/property_status_service.dart';
import 'package:paradigm_mex/service/property_types_service.dart';
import 'package:velocity_x/velocity_x.dart';

class FilterDialog extends StatefulWidget {
  FilterDialog();

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

final commaFormatter = NumberFormat('#,##,###.##');

final moneyFormatter = NumberFormat.currency(
  name: '',
  locale: 'es_mx',
);

String priceFormatter(double value) {
  return moneyFormatter.format(value);
}

String sizeFormatter(double value) {
  return '${commaFormatter.format(value)}m²';
}

class _FilterDialogState extends State<FilterDialog> {
  _FilterDialogState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersBloc, FiltersState>(builder: (context, state) {
      if (state is FiltersLoadSuccessState || state is FiltersChangedState) {
        PropertyFilters propertyFilters = PropertyFilters();

        if (state is FiltersLoadSuccessState) {
          propertyFilters = state.propertyFilters;
        }

        if (state is FiltersChangedState) {
          propertyFilters = state.propertyFilters;
        }

        return SafeArea(
            child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      foregroundColor: Color.fromRGBO(33, 33, 33, 1.0),
                      title: Text(S.of(context).filters),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              BlocProvider.of<FiltersBloc>(context).add(
                                  FiltersChangedEvent(
                                      propertyFilters: propertyFilters));
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                    body: ListView(children: [
                      FilterCard(title: S.of(context).price_title, children: [
                        Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: RangeFilterWidget(
                                propertyFilters.price, 20, priceFormatter))
                      ]),
                      FilterCard(
                        title: S.of(context).bedrooms,
                        children: [
                          ChoiceFilterWidget(propertyFilters.bedrooms)
                        ],
                      ),
                      FilterCard(
                        title: S.of(context).bathrooms,
                        children: [
                          ChoiceFilterWidget(propertyFilters.bathrooms),
                        ],
                      ),
                      FilterCard(title: S.of(context).size, children: [
                        Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: RangeFilterWidget(
                                propertyFilters.size, 60, sizeFormatter))
                      ]),
                      FilterCard(
                          title: S.of(context).type,
                          children: [ChipFilterWidget(propertyFilters.types)]),
                      FilterCard(title: S.of(context).amenities, children: [
                        ChipFilterWidget(propertyFilters.amenities)
                      ]),
                      FilterCard(
                          title: S.of(context).status,
                          children: [ListFilterWidget(propertyFilters.status)]),
                    ]))));
      } else if (state is FiltersLoadFailureState) {
        return Center(
          child: Text('Error fetching filters'),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        );
      }
    });
  }
}

class ChoiceFilterWidget extends StatefulWidget {
  final ChoicePropertyFilter filter;

  ChoiceFilterWidget(this.filter);

  @override
  _ChoiceFilterWidget createState() => _ChoiceFilterWidget(this.filter);
}

class _ChoiceFilterWidget extends State<ChoiceFilterWidget> {
  final ChoicePropertyFilter filter;

  _ChoiceFilterWidget(this.filter);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
    return Align(
        alignment: Alignment.centerLeft,
        child: ToggleButtons(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderColor: Color.fromRGBO(0, 0, 0, 0.12),
          children: filter.labels.map((label) {
            return Text(
              label,
              style: textStyle,
            );
          }).toList(),
          isSelected: filter.toBooleanValues(),
          //selectedColor: Colors.white,
          fillColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < filter.toBooleanValues().length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  this.filter.values[buttonIndex] = true;
                } else {
                  this.filter.values[buttonIndex] = false;
                }
              }
            });
          },
        ));
  }
}

class RangeFilterWidget extends StatefulWidget {
  final RangePropertyFilter filter;

  final int divisions;
  final Function(double) labelFormatter;

  RangeFilterWidget(this.filter, this.divisions, this.labelFormatter);

  @override
  _RangeFilterWidget createState() =>
      _RangeFilterWidget(this.filter, this.divisions, this.labelFormatter);
}

class _RangeFilterWidget extends State<RangeFilterWidget> {
  final RangePropertyFilter filter;
  final int divisions;
  late RangeValues range;
  final Function(double) labelFormatter;

  _RangeFilterWidget(this.filter, this.divisions, this.labelFormatter) {
    range = RangeValues(filter.values[0], filter.values[1]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
    BoxDecoration textBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Color.fromRGBO(33, 33, 33, 0.08),
    );
    return Row(children: [
      Container(
        child: Text(filter.labels[0], style: textStyle),
        padding: EdgeInsets.all(6.0),
        decoration: textBoxDecoration,
      ),
      Expanded(
          child: RangeSlider(
        values: range,
        min: this.filter.min,
        max: this.filter.max,
        divisions: this.divisions,
        activeColor: Theme.of(context).colorScheme.secondary,
        labels: RangeLabels(
          labelFormatter(range.start),
          labelFormatter(range.end),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            range = values;
            this.filter.values[0] = range.start;
            this.filter.values[1] = range.end;
          });
        },
      )),
      Container(
        child: Text(filter.labels[1], style: textStyle),
        padding: EdgeInsets.all(6.0),
        decoration: textBoxDecoration,
      ),
    ]);
  }
}

class ChipFilterWidget extends StatefulWidget {
  final MultipleChoicePropertyFilter filter;

  ChipFilterWidget(this.filter);

  @override
  _ChipFilterWidget createState() => _ChipFilterWidget(this.filter);
}

class _ChipFilterWidget extends State<ChipFilterWidget> {
  final MultipleChoicePropertyFilter filter;

  _ChipFilterWidget(this.filter);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          color: Color.fromRGBO(0, 0, 0, 0.87),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );

    List<Widget> list = [];
    for (int i = 0; i < this.filter.labels.length; i++) {
      list.add(ChoiceChip(
        selectedColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Color.fromRGBO(250, 238, 238, 1.0),
        onSelected: (selected) {
          setState(() {
            this.filter.values[i] = selected;
            int anyIndex = this
                .filter
                .labels
                .indexWhere((element) => element.name == "any");
            // is Any selected?
            bool anyIsSelected = this.filter.values[i];
            if (i == anyIndex) {
              this.filter.values[i] = true;
              if (anyIsSelected) {
                for (int i = 0; i < this.filter.values.length; i++) {
                  if (i != anyIndex) {
                    this.filter.values[i] = false;
                  }
                }
              } else {}
            } else {
              bool othersAreSelected = false;
              for (int i = 0; i < this.filter.values.length; i++) {
                if (i != anyIndex) {
                  othersAreSelected |= this.filter.values[i];
                }
              }
              this.filter.values[anyIndex] = !othersAreSelected;
            }
          });
        },
        label: Text(
            (GeneralServices.getLocale() == "en"
                ? this.filter.labels[i]?.enLabel
                : this.filter.labels[i]?.esLabel),
            style: textStyle),
        selected: this.filter.values[i],
      ));
    }

    return Align(
        alignment: Alignment.centerLeft,
        child: Wrap(alignment: WrapAlignment.start, children: list));
  }
}

class ListFilterWidget extends StatefulWidget {
  final MultipleChoicePropertyFilter filter;

  ListFilterWidget(this.filter);

  @override
  _ListFilterWidget createState() => _ListFilterWidget(this.filter);
}

class _ListFilterWidget extends State<ListFilterWidget> {
  final MultipleChoicePropertyFilter filter;

  _ListFilterWidget(this.filter);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < this.filter.labels.length; i++) {
      list.add(CheckboxListTile(
        checkColor: Colors.white,
        activeColor: Theme.of(context).colorScheme.secondary,
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text((GeneralServices.getLocale() == "en"
            ? this.filter.labels[i]?.enLabel
            : this.filter.labels[i]?.esLabel)),
        value: this.filter.values[i],
        onChanged: (bool? value) {
          setState(() {
            this.filter.values[i] = value!;
          });
        },
      ));
    }

    return ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: list);
  }
}

class FilterCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  FilterCard({required this.title, required this.children}) : super() {}

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.secondary),
                        ))),
                ...children
              ])),
    );
  }
}

abstract class PropertyFilter {
  late List<dynamic> labels;
  late List<dynamic> values;

  PropertyFilter(this.labels, this.values);

  static List<String> valuesFromBoolean(List<bool> values) {
    return values.map((value) => value.toString()).toList();
  }

  List<bool> toBooleanValues() {
    return this.values.map((value) => value as bool).toList();
  }

  List<double> toDoubleValues() {
    return this.values.map((value) => value as double).toList();
  }

  bool matches(Property property, dynamic field);
}


class TextPropertyFilter extends PropertyFilter {
  final String text;

  TextPropertyFilter(List<String> labels, List values, this.text)
      : super(labels, values);

  @override
  bool matches(Property property, dynamic field) {
    if((field as String).isNotEmptyAndNotNull || (values[0] as String).isNotEmptyAndNotNull) {

      return field.toLowerCase().contains((values[0]as String).toLowerCase());
    }
    return true;
  }
}

class RangePropertyFilter extends PropertyFilter {
  final double min;
  final double max;

  RangePropertyFilter(List<String> labels, List values, this.min, this.max)
      : super(labels, values);

  @override
  bool matches(Property property, dynamic field) {
    return field as double >= this.values[0] && (this.values[1] == this.max || field <= this.values[1]);
  }
}

class ChoicePropertyFilter extends PropertyFilter {
  ChoicePropertyFilter(List<String> labels, List values)
      : super(labels, values);

  @override
  bool matches(Property property, dynamic field) {
    return (field >= (this.values.indexWhere((element) => element == true)));
  }
}

class SingleChoicePropertyFilter extends PropertyFilter {
  SingleChoicePropertyFilter(String label, bool value)
      : super([label], [value]);

  @override
  bool matches(Property property, dynamic field) {
    return field == this.values[0];
  }
}

class MultipleChoicePropertyFilter extends PropertyFilter {
  MultipleChoicePropertyFilter(List<PropertyEnum> labels, List values)
      : super(labels, values);

  @override
  bool matches(Property property, dynamic propertyField) {
    // field is a list of amenities
    // the property must have all active amenities

    bool match = false;
    int anyIndex = this.labels.indexWhere((element) => element.name == "any");
    //is any selected?
    if (anyIndex > -1 && this.values[anyIndex]) {
      match = true;
    } else {
      if (propertyField is List) {
        match = true;
        for (int i = 0; i < this.values.length; i++) {
          if (this.values[i]) {
            String selected = this.labels[i].name;
            List<String> amenities = property.amenitiesIds ?? [];
            bool selectedValue = amenities.contains(selected);
            match &= selectedValue;
          }
        }
      } else if (propertyField is PropertyEnum) {
        int index = this
            .labels
            .indexWhere((element) => element.name == propertyField.name);
        match |= this.values[index] as bool;
      } else if (propertyField is String) {
        int index =
            this.labels.indexWhere((element) => element.name == propertyField);
        match |= this.values[index] as bool;
      }
    }
    return match;
  }
}

List<Property> filterProperties(
    List<Property> properties, PropertyFilters filters) {
  if (filters.initialized) {
    return properties.where((property) {
      return filterProperty(property, filters);
    }).toList();
  }
  return properties;
}

bool filterProperty(Property property, PropertyFilters? filters) {
  if (filters != null && filters.initialized) {
    return filters.bedrooms.matches(property, property.bedrooms) &&
        filters.bathrooms.matches(property, property.bathrooms) &&
        filters.price.matches(property, property.currentPrice) &&
        filters.size.matches(property, property.meters) &&
        filters.amenities.matches(property, property.amenitiesIds) &&
        filters.types.matches(property, property.type) &&
        filters.status.matches(property, property.status) &&
        (filters.propertyName.matches(property, property.propertyName)|| filters.propertyName.matches(property, property.streetAddress));
  }
  return true;
}

class PropertyFilters {
  late ChoicePropertyFilter bedrooms;
  late ChoicePropertyFilter bathrooms;
  late RangePropertyFilter price;
  late RangePropertyFilter size;
  late TextPropertyFilter propertyName;

  late MultipleChoicePropertyFilter status;
  late MultipleChoicePropertyFilter types;
  late MultipleChoicePropertyFilter amenities;
  late bool initialized = false;
  late SingleChoicePropertyFilter favorite;

  PropertyFilters();

  Future<void> initialize(BuildContext context) async {
    if (!initialized) {
      bedrooms = ChoicePropertyFilter([S
          .of(context)
          .any, "1+", "2+", "3+", "4+"],
          [true, false, false, false, false]);

      bathrooms = ChoicePropertyFilter(
          [S
              .of(context)
              .any, "1+", "2+", "3+"], [true, false, false, false]);
      price = RangePropertyFilter(
        ["\$0", "\$1,5m+"],
        [0.0, 1500000.0],
        0.0,
        1500000.0,
      );

      size = RangePropertyFilter(
        ['0m²', '3000m²+'],
        [0.0, 3000.0],
        0.0,
        3000.0,
      );

      propertyName = TextPropertyFilter(['Property Name'], [''], '');

      List<PropertyEnum> s =
      await PropertyStatusService().getAllPropertyStatuses();
      status = MultipleChoicePropertyFilter(s, List.filled(s.length, true));

      List<PropertyEnum> t = await PropertyTypesService().getAllPropertyTypes();
      List<bool> typeChoices = List.filled(t.length, false);
      int index = t.indexWhere((element) => element.name == "any");
      typeChoices[index] = true;

      types = MultipleChoicePropertyFilter(t, typeChoices);

      List<PropertyEnum> a = await AmenitiesService().getAllAmenities();
      List<bool> amenityChoices = List.filled(a.length, false);
      index = a.indexWhere((element) => element.name == "any");
      amenityChoices[index] = true;

      amenities = MultipleChoicePropertyFilter(a, amenityChoices);

      favorite = SingleChoicePropertyFilter(S
          .of(context)
          .favorite, false);
      initialized = true;
    }
  }
}
