var testJSON = {
    "template": "<div><h1>{{0}}</h1>, {{1}} and <h2>{{2}}</h2></div>",
    "data": [
        ["test1", "test2", "test3"],
        ["test1_1", "test2_1", "test3_1"],
        ["test1_2", "test2_2", "test3_2"]
    ]
}


window.onload = function() {
    var event = new Event("ajaxload"),
        testobject = document.getElementById("test");


    testobject.addEventListener("ajaxload", function() {
        this.innerHTML = templater(testJSON);
    }, false);

    testobject.dispatchEvent(event);
};





function templater(json) {
    var template = json.template,
        data = json.data,
        output = "";

    for (i = 0; i < data.length; i++) {
        var temp = template;
        for (k = 0; k < data[i].length; k++) {
            temp = temp.replace("{{" + k + "}}", data[i][k]);
        }
        output += temp;
    }
    return output
}



var template =
    'My skills:' +
    '<%if(this.showSkills) {%>' +
    '<%for(var index in this.skills) {%>' +
    '<a href="#"><%this.skills[index]%></a>' +
    '<%}%>' +
    '<%} else {%>' +
    '<p>none</p>' +
    '<%}%>';
console.log(templater2(template, {
    skills: ["js", "html", "css"],
    showSkills: true
}));


function templater2(html, options) {

    var re = /<%(.+?)%>/g,
        reExp = /(^( )?(var|if|for|else|switch|case|break|{|}|;))(.*)?/g,
        code = 'with(obj) { var r=[];\n',
        cursor = 0,
        result,
        match;

    var add = function(line, js) {
        js ? (code += line.match(reExp) ? line + '\n' : 'r.push(' + line + ');\n') :
            (code += line != '' ? 'r.push("' + line.replace(/"/g, '\\"') + '");\n' : '');
        return add;
    }

    while (match = re.exec(html)) {
        add(html.slice(cursor, match.index))(match[1], true);
        cursor = match.index + match[0].length;
    }

    add(html.substr(cursor, html.length - cursor));
    code = (code + 'return r.join(""); }').replace(/[\r\t\n]/g, ' ');
    try { result = new Function('obj', code).apply(options, [options]); } catch (err) { console.error("'" + err.message + "'", " in \n\nCode:\n", code, "\n"); }
    return result;

}