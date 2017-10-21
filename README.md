
# react-native-drag-n-drop

## Read first
IMPORTANT: I had to unpublish this package from npm because can't figure out how to make work the swift code as a library with react-native manager. If you want to help, take a look here:
https://github.com/neiker/react-native-drag-n-drop/blob/master/ios/RNDragNDrop/RNDropTargetViewModule.m
Anyway, it works if you copy and paste the files on xcode within the main project.


You can see it in action on the [mural iOS app](https://itunes.apple.com/us/app/mural-visual-collaboration/id1156631145?mt=8) and on this video:

<a href="http://embed.vidyard.com/share/1uf7n97aPdiXhyVc9HSW9r" target="_blank">
    <img src="https://user-images.githubusercontent.com/688444/30982926-3c9313b2-a45f-11e7-9247-dc12601a78c3.png" width="400" />
</a>

## Getting started

`$ npm install react-native-drag-n-drop --save`

### Mostly automatic installation

`$ react-native link react-native-drag-n-drop`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-drag-n-drop` and add `RNDragNDrop.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNDragNDrop.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<


## Usage

You need to wrap the section of your app you like to be able to receibe drops with the DropTarget component. 

```javascript
import { DropTarget } from 'react-native-drag-n-drop';

function dropHandler(event) {
  console.log(event.nativeEvent.dropPoint);
  console.log(event.nativeEvent.files);
  console.log(event.nativeEvent.text);
  console.log(event.nativeEvent.url);
}

const dropTargetStyle = {
  width: 400,
  height: 400,
};

<DropTarget onDrop={dropHandler} style={dropTargetStyle}>
  // your content here
</DropTarget>
```
  

## TODO

- Implement drag source to move elements inside the app and export them. 
