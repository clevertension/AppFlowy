import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/startup/startup.dart';
import 'package:appflowy/workspace/application/menu/menu_bloc.dart';
import 'package:appflowy/workspace/application/sidebar/folder/folder_bloc.dart';
import 'package:appflowy/workspace/application/tabs/tabs_bloc.dart';
import 'package:appflowy/workspace/application/view/view_ext.dart';
import 'package:appflowy/workspace/presentation/home/menu/view/view_item.dart';
import 'package:appflowy_backend/protobuf/flowy-folder2/view.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra/image.dart';
import 'package:flowy_infra_ui/flowy_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalFolder extends StatelessWidget {
  const PersonalFolder({
    super.key,
    required this.views,
  });

  final List<ViewPB> views;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FolderBloc>(
      create: (context) => FolderBloc(type: FolderCategoryType.personal)
        ..add(
          const FolderEvent.initial(),
        ),
      child: BlocBuilder<FolderBloc, FolderState>(
        builder: (context, state) {
          return Column(
            children: [
              PersonalFolderHeader(
                onPressed: () => context
                    .read<FolderBloc>()
                    .add(const FolderEvent.expandOrUnExpand()),
                onAdded: () => context
                    .read<FolderBloc>()
                    .add(const FolderEvent.expandOrUnExpand(isExpanded: true)),
              ),
              if (state.isExpanded)
                ...views.map(
                  (view) => ViewItem(
                    key: ValueKey(
                      '${FolderCategoryType.personal.name} ${view.id}',
                    ),
                    categoryType: FolderCategoryType.personal,
                    isFirstChild: view.id == views.first.id,
                    view: view,
                    level: 0,
                    leftPadding: 16,
                    isFeedback: false,
                    onSelected: (view) {
                      getIt<TabsBloc>().add(
                        TabsEvent.openPlugin(
                          plugin: view.plugin(),
                          view: view,
                        ),
                      );
                    },
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class PersonalFolderHeader extends StatefulWidget {
  const PersonalFolderHeader({
    super.key,
    required this.onPressed,
    required this.onAdded,
  });

  final VoidCallback onPressed;
  final VoidCallback onAdded;

  @override
  State<PersonalFolderHeader> createState() => _PersonalFolderHeaderState();
}

class _PersonalFolderHeaderState extends State<PersonalFolderHeader> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    const iconSize = 26.0;
    return MouseRegion(
      onEnter: (event) => setState(() => onHover = true),
      onExit: (event) => setState(() => onHover = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlowyTextButton(
            LocaleKeys.sideBar_personal.tr(),
            tooltip: LocaleKeys.sideBar_clickToHidePersonal.tr(),
            constraints: const BoxConstraints(maxHeight: iconSize),
            padding: const EdgeInsets.all(4),
            fillColor: Colors.transparent,
            onPressed: widget.onPressed,
          ),
          if (onHover) ...[
            const Spacer(),
            FlowyIconButton(
              tooltipText: LocaleKeys.sideBar_addAPage.tr(),
              hoverColor: Theme.of(context).colorScheme.secondaryContainer,
              iconPadding: const EdgeInsets.all(2),
              height: iconSize,
              width: iconSize,
              icon: const FlowySvg(name: 'editor/add'),
              onPressed: () {
                context.read<MenuBloc>().add(
                      MenuEvent.createApp(
                        LocaleKeys.menuAppHeader_defaultNewPageName.tr(),
                        index: 0,
                      ),
                    );
                widget.onAdded();
              },
            ),
          ]
        ],
      ),
    );
  }
}
