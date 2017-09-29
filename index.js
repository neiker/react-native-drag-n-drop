import React, { PropTypes } from 'react';
import { 
  Platform,
  requireNativeComponent,
  View,
} from 'react-native';

export function DropTarget(props) {
  return (
    <RNDragNDropTargetView
      {...props}
    />
  );
}

DropTarget.propTypes = {
  onSessionDidEnter: PropTypes.func,
  onSessionDidUpdate: PropTypes.func,
  onSessionDidExit: PropTypes.func,
  onSessionDidEnd: PropTypes.func,

  onWillDrop: PropTypes.func,
  onDrop: PropTypes.func,
};


const RNDragNDropTargetView = Platform.OS === 'ios' ? requireNativeComponent('RNDragNDropTargetView', DropTarget) : View;