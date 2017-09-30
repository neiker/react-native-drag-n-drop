/**
 * Stub of RNDragNDrop for iOS.
 *
 * @providesModule DropTarget
 * @flow
 */

import React from 'react';
import PropTypes from 'prop-types';

import {
  requireNativeComponent,
  Platform,
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

const RNDragNDropTargetView = Platform.OS === 'ios' ? requireNativeComponent('RNDropTargetView', DropTarget) : View;
