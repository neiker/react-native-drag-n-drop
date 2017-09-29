
# react-native-drag-n-drop

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
  
