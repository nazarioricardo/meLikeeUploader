# meLikeeUploader
Upload to meLikee's Cloudkit database from Mac OS X

# Why?
Because the audiofiles will be edited on my computer, therefore with this app I eliminate the step of having to save 
an ad-hoc deployment on iOS every time I want to upload more files.

# What kind of code can I find here?
The CloudkitManager singleton has some standard Objective-c methods for uploading media files to Cloudkit.

# What's coming next?
Unfortunately, this app cannot upload straight to the production environment on Cloudkit because it doesn't work with 
Apple's sandboxing, and Apple will not permit any distribution if the app isn't sandboxed. So I am in the process of 
learning how to access files when sandbox is enabled.
