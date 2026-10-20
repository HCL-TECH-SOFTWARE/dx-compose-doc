# Video start and end points

File components or elements support video files stored in HTML5 video formats, including MP4, WebM, or Ogg.

You can preview the video in the content form and set starting and ending points for the video.

The following code snippet demonstrates an HTML5 video player:

```html
<video class="videoPlayer" controls="" preload="metadata" src='[Element context="current" 
type="content" key="file" format="url"]#t=[Element context="current" type="content" key="file" 
format="startTime_sec"],[Element context="current" type="content" key="file" format="endTime_sec"]'>
         Your browser does not support the video tag.
   </video>
```

You can retrieve the starting and ending points by using the component or element tag and the parameter `format="startTime"` or `format="endTime"`, which return the time in seconds. The `startTime_msec` and `endTime_msec` parameters return the time in milliseconds.

The starting point frame generates the thumbnail of the video. You can retrieve the thumbnail with the parameter `rendition="thumbnail"`.
