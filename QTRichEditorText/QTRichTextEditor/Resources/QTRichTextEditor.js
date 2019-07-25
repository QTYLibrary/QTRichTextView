/*
 *
 * QTRichTextEditor v1.0.0
 *
 * Created by QinTuanye on 2019/7/24.
 * Copyright © 2019 QinTuanye. All rights reserved.
 *
 */

var qt_editor = {};

// If we are using iOS or desktop
qt_editor.isUsingiOS = true;

// If the user is draging
qt_editor.isDragging = false;

// The current selection
qt_editor.currentSelection;

// The current editing image
qt_editor.currentEditingImage;

// The current editing link
qt_editor.currentEditingLink;

// The objects that are enabled
qt_editor.enabledItems = {};

// Height of content window, will be set by viewController
qt_editor.contentHeight = 244;

// Sets to true when extra footer gap shows and requires to hide
qt_editor.updateScrollOffset = false;

/**
 * The initializer function that must be called onLoad
 */
qt_editor.init = function() {
    
    $('#qt_editor_content').on('touchend', function(e) {
                                qt_editor.enabledEditingItems(e);
                                var clicked = $(e.target);
                                if (!clicked.hasClass('zs_active')) {
                                $('img').removeClass('zs_active');
                                }
                                });
    
    $(document).on('selectionchange',function(e){
                   qt_editor.calculateEditorHeightWithCaretPosition();
                   qt_editor.setScrollPosition();
                   qt_editor.enabledEditingItems(e);
                   });
    
    $(window).on('scroll', function(e) {
                 qt_editor.updateOffset();
                 });
    
    // Make sure that when we tap anywhere in the document we focus on the editor
    $(window).on('touchmove', function(e) {
                 qt_editor.isDragging = true;
                 qt_editor.updateScrollOffset = true;
                 qt_editor.setScrollPosition();
                 qt_editor.enabledEditingItems(e);
                 });
    $(window).on('touchstart', function(e) {
                 qt_editor.isDragging = false;
                 });
    $(window).on('touchend', function(e) {
                 if (!qt_editor.isDragging && (e.target.id == "qt_editor_footer"||e.target.nodeName.toLowerCase() == "html")) {
                 qt_editor.focusEditor();
                 }
                 });
    
}//end

qt_editor.updateOffset = function() {
    
    if (!qt_editor.updateScrollOffset)
        return;
    
    var offsetY = window.document.body.scrollTop;
    
    var footer = $('#qt_editor_footer');
    
    var maxOffsetY = footer.offset().top - qt_editor.contentHeight;
    
    if (maxOffsetY < 0)
        maxOffsetY = 0;
    
    if (offsetY > maxOffsetY)
    {
        window.scrollTo(0, maxOffsetY);
    }
    
    qt_editor.setScrollPosition();
}

// This will show up in the XCode console as we are able to push this into an NSLog.
qt_editor.debug = function(msg) {
    window.location = 'debug://'+msg;
}


qt_editor.setScrollPosition = function() {
    var position = window.pageYOffset;
    window.location = 'scroll://'+position;
}


qt_editor.setPlaceholder = function(placeholder) {
    
    var editor = $('#qt_editor_content');
    
    //set placeHolder
	editor.attr("placeholder",placeholder);
	
    //set focus			 
	editor.focusout(function(){
        var element = $(this);        
        if (!element.text().trim().length) {
            element.empty();
        }
    });
	
	
    
}

qt_editor.setFooterHeight = function(footerHeight) {
    var footer = $('#qt_editor_footer');
    footer.height(footerHeight + 'px');
}

qt_editor.getCaretYPosition = function() {
    var sel = window.getSelection();
    // Next line is comented to prevent deselecting selection. It looks like work but if there are any issues will appear then uconmment it as well as code above.
    //sel.collapseToStart();
    var range = sel.getRangeAt(0);
    var span = document.createElement('span');// something happening here preventing selection of elements
    range.collapse(false);
    range.insertNode(span);
    var topPosition = span.offsetTop;
    span.parentNode.removeChild(span);
    return topPosition;
}

qt_editor.calculateEditorHeightWithCaretPosition = function() {
    
    var padding = 50;
    var c = qt_editor.getCaretYPosition();
    
    var editor = $('#qt_editor_content');
    
    var offsetY = window.document.body.scrollTop;
    var height = qt_editor.contentHeight;
    
    var newPos = window.pageYOffset;
    
    if (c < offsetY) {
        newPos = c;
    } else if (c > (offsetY + height - padding)) {
        newPos = c - height + padding - 18;
    }
    
    window.scrollTo(0, newPos);
}

qt_editor.backuprange = function(){
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);
    qt_editor.currentSelection = {"startContainer": range.startContainer, "startOffset":range.startOffset,"endContainer":range.endContainer, "endOffset":range.endOffset};
}

qt_editor.restorerange = function(){
    var selection = window.getSelection();
    selection.removeAllRanges();
    var range = document.createRange();
    range.setStart(qt_editor.currentSelection.startContainer, qt_editor.currentSelection.startOffset);
    range.setEnd(qt_editor.currentSelection.endContainer, qt_editor.currentSelection.endOffset);
    selection.addRange(range);
}

qt_editor.getSelectedNode = function() {
    var node,selection;
    if (window.getSelection) {
        selection = getSelection();
        node = selection.anchorNode;
    }
    if (!node && document.selection) {
        selection = document.selection
        var range = selection.getRangeAt ? selection.getRangeAt(0) : selection.createRange();
        node = range.commonAncestorContainer ? range.commonAncestorContainer :
        range.parentElement ? range.parentElement() : range.item(0);
    }
    if (node) {
        return (node.nodeName == "#text" ? node.parentNode : node);
    }
};

qt_editor.setBold = function() {
    document.execCommand('bold', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setItalic = function() {
    document.execCommand('italic', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setSubscript = function() {
    document.execCommand('subscript', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setSuperscript = function() {
    document.execCommand('superscript', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setStrikeThrough = function() {
    document.execCommand('strikeThrough', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setUnderline = function() {
    document.execCommand('underline', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setBlockquote = function() {
    var range = document.getSelection().getRangeAt(0);
    formatName = range.commonAncestorContainer.parentElement.nodeName === 'BLOCKQUOTE'
    || range.commonAncestorContainer.nodeName === 'BLOCKQUOTE' ? '<P>' : '<BLOCKQUOTE>';
    document.execCommand('formatBlock', false, formatName)
    qt_editor.enabledEditingItems();
}

qt_editor.removeFormating = function() {
    document.execCommand('removeFormat', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setHorizontalRule = function() {
    document.execCommand('insertHorizontalRule', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setHeading = function(heading) {
    var current_selection = $(qt_editor.getSelectedNode());
    var t = current_selection.prop("tagName").toLowerCase();
    var is_heading = (t == 'h1' || t == 'h2' || t == 'h3' || t == 'h4' || t == 'h5' || t == 'h6');
    if (is_heading && heading == t) {
        var c = current_selection.html();
        current_selection.replaceWith(c);
    } else {
        document.execCommand('formatBlock', false, '<'+heading+'>');
    }
    
    qt_editor.enabledEditingItems();
}

qt_editor.setParagraph = function() {
    var current_selection = $(qt_editor.getSelectedNode());
    var t = current_selection.prop("tagName").toLowerCase();
    var is_paragraph = (t == 'p');
    if (is_paragraph) {
        var c = current_selection.html();
        current_selection.replaceWith(c);
    } else {
        document.execCommand('formatBlock', false, '<p>');
    }
    
    qt_editor.enabledEditingItems();
}

// Need way to remove formatBlock
console.log('WARNING: We need a way to remove formatBlock items');

qt_editor.undo = function() {
    document.execCommand('undo', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.redo = function() {
    document.execCommand('redo', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setOrderedList = function() {
    document.execCommand('insertOrderedList', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setUnorderedList = function() {
    document.execCommand('insertUnorderedList', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setJustifyCenter = function() {
    document.execCommand('justifyCenter', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setJustifyFull = function() {
    document.execCommand('justifyFull', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setJustifyLeft = function() {
    document.execCommand('justifyLeft', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setJustifyRight = function() {
    document.execCommand('justifyRight', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setIndent = function() {
    document.execCommand('indent', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setOutdent = function() {
    document.execCommand('outdent', false, null);
    qt_editor.enabledEditingItems();
}

qt_editor.setFontFamily = function(fontFamily) {

	qt_editor.restorerange();
	document.execCommand("styleWithCSS", null, true);
	document.execCommand("fontName", false, fontFamily);
	document.execCommand("styleWithCSS", null, false);
	qt_editor.enabledEditingItems();
		
}

qt_editor.setFontSize = function(fontSize){
    document.execCommand("fontSize", false, fontSize);
    qt_editor.enabledEditingItems();
}

qt_editor.setTextColor = function(color) {
		
    qt_editor.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('foreColor', false, color);
    document.execCommand("styleWithCSS", null, false);
    qt_editor.enabledEditingItems();
    // document.execCommand("removeFormat", false, "foreColor"); // Removes just foreColor
	
}

qt_editor.setBackgroundColor = function(color) {
    qt_editor.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('hiliteColor', false, color);
    document.execCommand("styleWithCSS", null, false);
    qt_editor.enabledEditingItems();
}

// Needs addClass method

qt_editor.insertLink = function(url, title) {
    
    qt_editor.restorerange();
    var sel = document.getSelection();
    console.log(sel);
    if (sel.toString().length != 0) {
        if (sel.rangeCount) {
            
            var el = document.createElement("a");
            el.setAttribute("href", url);
            el.setAttribute("title", title);
            
            var range = sel.getRangeAt(0).cloneRange();
            range.surroundContents(el);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    }
    else
    {
        document.execCommand("insertHTML",false,"<a href='"+url+"'>"+title+"</a>");
    }
    
    qt_editor.enabledEditingItems();
}

qt_editor.updateLink = function(url, title) {
    
    qt_editor.restorerange();
    
    if (qt_editor.currentEditingLink) {
        var c = qt_editor.currentEditingLink;
        c.attr('href', url);
        c.attr('title', title);
    }
    qt_editor.enabledEditingItems();
    
}//end

qt_editor.updateImage = function(url, alt) {
    
    qt_editor.restorerange();
    
    if (qt_editor.currentEditingImage) {
        var c = qt_editor.currentEditingImage;
        c.attr('src', url);
        c.attr('alt', alt);
    }
    qt_editor.enabledEditingItems();
    
}//end

qt_editor.updateImageBase64String = function(imageBase64String, alt) {
    
    qt_editor.restorerange();
    
    if (qt_editor.currentEditingImage) {
        var c = qt_editor.currentEditingImage;
        var src = 'data:image/jpeg;base64,' + imageBase64String;
        c.attr('src', src);
        c.attr('alt', alt);
    }
    qt_editor.enabledEditingItems();
    
}//end


qt_editor.unlink = function() {
    
    if (qt_editor.currentEditingLink) {
        var c = qt_editor.currentEditingLink;
        c.contents().unwrap();
    }
    qt_editor.enabledEditingItems();
}

qt_editor.quickLink = function() {
    
    var sel = document.getSelection();
    var link_url = "";
    var test = new String(sel);
    var mailregexp = new RegExp("^(.+)(\@)(.+)$", "gi");
    if (test.search(mailregexp) == -1) {
        checkhttplink = new RegExp("^http\:\/\/", "gi");
        if (test.search(checkhttplink) == -1) {
            checkanchorlink = new RegExp("^\#", "gi");
            if (test.search(checkanchorlink) == -1) {
                link_url = "http://" + sel;
            } else {
                link_url = sel;
            }
        } else {
            link_url = sel;
        }
    } else {
        checkmaillink = new RegExp("^mailto\:", "gi");
        if (test.search(checkmaillink) == -1) {
            link_url = "mailto:" + sel;
        } else {
            link_url = sel;
        }
    }
    
    var html_code = '<a href="' + link_url + '">' + sel + '</a>';
    qt_editor.insertHTML(html_code);
    
}

qt_editor.prepareInsert = function() {
    qt_editor.backuprange();
}

qt_editor.insertImage = function(url, alt) {
    qt_editor.restorerange();
    var html = '<img src="'+url+'" alt="'+alt+'" />';
    qt_editor.insertHTML(html);
    qt_editor.enabledEditingItems();
}

qt_editor.insertImageBase64String = function(imageBase64String, alt) {
    qt_editor.restorerange();
    var html = '<img src="data:image/jpeg;base64,'+imageBase64String+'" alt="'+alt+'" />';
    qt_editor.insertHTML(html);
    qt_editor.enabledEditingItems();
}

qt_editor.setHTML = function(html) {
    var editor = $('#qt_editor_content');
    editor.html(html);
}

qt_editor.insertHTML = function(html) {
    document.execCommand('insertHTML', false, html);
    qt_editor.enabledEditingItems();
}

qt_editor.getHTML = function() {
    
    // Images
    var img = $('img');
    if (img.length != 0) {
        $('img').removeClass('zs_active');
        $('img').each(function(index, e) {
                      var image = $(this);
                      var zs_class = image.attr('class');
                      if (typeof(zs_class) != "undefined") {
                      if (zs_class == '') {
                      image.removeAttr('class');
                      }
                      }
                      });
    }
    
    // Blockquote
    var bq = $('blockquote');
    if (bq.length != 0) {
        bq.each(function() {
                var b = $(this);
                if (b.css('border').indexOf('none') != -1) {
                b.css({'border': ''});
                }
                if (b.css('padding').indexOf('0px') != -1) {
                b.css({'padding': ''});
                }
                });
    }
    
    // Get the contents
    var h = document.getElementById("qt_editor_content").innerHTML;
    
    return h;
}

qt_editor.getText = function() {
    return $('#qt_editor_content').text();
}

qt_editor.isCommandEnabled = function(commandName) {
    return document.queryCommandState(commandName);
}

qt_editor.enabledEditingItems = function(e) {
    
    console.log('enabledEditingItems');
    var items = [];
    
    var fontSizeblock = document.queryCommandValue('fontSize');
    if (fontSizeblock.length > 0) {
        items.push('fontSize:' + fontSizeblock);
    }
    
    if (qt_editor.isCommandEnabled('bold')) {
        items.push('bold');
    }
    if (qt_editor.isCommandEnabled('italic')) {
        items.push('italic');
    }
    if (qt_editor.isCommandEnabled('subscript')) {
        items.push('subscript');
    }
    if (qt_editor.isCommandEnabled('superscript')) {
        items.push('superscript');
    }
    if (qt_editor.isCommandEnabled('strikeThrough')) {
        items.push('strikeThrough');
    }
    if (qt_editor.isCommandEnabled('underline')) {
        items.push('underline');
    }
    if (qt_editor.isCommandEnabled('insertOrderedList')) {
        items.push('orderedList');
    }
    if (qt_editor.isCommandEnabled('insertUnorderedList')) {
        items.push('unorderedList');
    }
    if (qt_editor.isCommandEnabled('justifyCenter')) {
        items.push('justifyCenter');
    }
    if (qt_editor.isCommandEnabled('justifyFull')) {
        items.push('justifyFull');
    }
    if (qt_editor.isCommandEnabled('justifyLeft')) {
        items.push('justifyLeft');
    }
    if (qt_editor.isCommandEnabled('justifyRight')) {
        items.push('justifyRight');
    }
    if (qt_editor.isCommandEnabled('insertHorizontalRule')) {
        items.push('horizontalRule');
    }
    var formatBlock = document.queryCommandValue('formatBlock');
    if (formatBlock.length > 0) {
        items.push(formatBlock);
    }
    // Images
    $('img').bind('touchstart', function(e) {
                  $('img').removeClass('zs_active');
                  $(this).addClass('zs_active');
                  });
    
    // Use jQuery to figure out those that are not supported
    if (typeof(e) != "undefined") {
        
        // The target element
        var s = qt_editor.getSelectedNode();
        var t = $(s);
        var nodeName = e.target.nodeName.toLowerCase();
        
        // Background Color
        var bgColor = t.css('backgroundColor');
        if (bgColor.length != 0 && bgColor != 'rgba(0, 0, 0, 0)' && bgColor != 'rgb(0, 0, 0)' && bgColor != 'transparent') {
            items.push('backgroundColor');
        }
        // Text Color
        var textColor = t.css('color');
        if (textColor.length != 0 && textColor != 'rgba(0, 0, 0, 0)' && textColor != 'rgb(0, 0, 0)' && textColor != 'transparent') {
            if (textColor == 'rgb(44, 44, 44)') {
                items.push('textColor:500');
            } else if (textColor == 'rgb(153, 153, 153)') {
                items.push('textColor:501');
            } else if (textColor == 'rgb(250, 85, 85)') {
                items.push('textColor:502');
            } else if (textColor == 'rgb(255, 120, 7)') {
                items.push('textColor:503');
            } else if (textColor == 'rgb(101, 205, 13)') {
                items.push('textColor:504');
            } else if (textColor == 'rgb(55, 151, 247)') {
                items.push('textColor:505');
            } else if (textColor == 'rgb(88, 86, 214)') {
                items.push('textColor:506');
            }
        }
		
		//Fonts
		var font = t.css('font-family');
		if (font.length != 0 && font != 'Arial, Helvetica, sans-serif') {
			items.push('fonts');	
		}
		
        // Link
        if (nodeName == 'a') {
            qt_editor.currentEditingLink = t;
            var title = t.attr('title');
            items.push('link:'+t.attr('href'));
            if (t.attr('title') !== undefined) {
                items.push('link-title:'+t.attr('title'));
            }
            
        } else {
            qt_editor.currentEditingLink = null;
        }
        // Blockquote
        if (nodeName == 'blockquote') {
            items.push('indent');
        }
        // Image
        if (nodeName == 'img') {
            qt_editor.currentEditingImage = t;
            items.push('image:'+t.attr('src'));
            if (t.attr('alt') !== undefined) {
                items.push('image-alt:'+t.attr('alt'));
            }
            
        } else {
            qt_editor.currentEditingImage = null;
        }
        
    }
    
    if (items.length > 0) {
        if (qt_editor.isUsingiOS) {
            //window.location = "zss-callback/"+items.join(',');
            window.location = "callback://0/"+items.join(',');
        } else {
            console.log("callback://"+items.join(','));
        }
    } else {
        if (qt_editor.isUsingiOS) {
            window.location = "zss-callback/";
        } else {
            console.log("callback://");
        }
    }
    
}

qt_editor.focusEditor = function() {
    
    // the following was taken from http://stackoverflow.com/questions/1125292/how-to-move-cursor-to-end-of-contenteditable-entity/3866442#3866442
    // and ensures we move the cursor to the end of the editor
    var editor = $('#qt_editor_content');
    var range = document.createRange();
    range.selectNodeContents(editor.get(0));
    range.collapse(false);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    editor.focus();
}

qt_editor.blurEditor = function() {
    $('#qt_editor_content').blur();
}

qt_editor.setCustomCSS = function(customCSS) {
    
    document.getElementsByTagName('style')[0].innerHTML=customCSS;
    
    //set focus
    /*editor.focusout(function(){
                    var element = $(this);
                    if (!element.text().trim().length) {
                    element.empty();
                    }
                    });*/
    
    
    
}

//end
