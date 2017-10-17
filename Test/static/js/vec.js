
function Vec(xPos = 0, yPos = 0){
	this.x = xPos;
	this.y = yPos;
}
Vec.newVec = function(v){
	return new Vec(v.x, v.y);
}
Vec.prototype.setCoords = function(x, y){
	this.x = x;
	this.y = y;
}
Vec.add = function(v1, v2){
	return new Vec(v1.x + v2.x, v1.y + v2.y);
}
Vec.sub = function(v1, v2){
	return new Vec(v1.x - v2.x, v1.y - v2.y);
}
Vec.mul = function(v, m){
	return new Vec(v.x * m, v.y * m);
}
Vec.div = function(v, d){
	if(d == 0){
		console.error("error, cannot divide vecor by zero");
	}
	return new Vec(v.x / d, v.y / d);
}
Vec.lgth = function(v){
	return Math.sqrt(v.x * v.x + v.y * v.y);
}
Vec.unit = function(v){
	return Vec.div(v, Vec.lgth(v));
}
Vec.reSize = function(v, len){
	if(len == 0){
		return new Vec();
	}
	return Vec.mul(Vec.unit(v), len);
}
Vec.lerp = function(vStart, vEnd, factor){
	return Vec.add(Vec.mul(Vec.sub(vEnd, vStart), factor), vStart);
}


