const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');

function drawPolygon(polygon) {
  ctx.beginPath();
  ctx.strkeStyle = 'blue';
  for (let i = 0; i < polygon.length; i++) {
    ctx.moveTo(polygon[i][0], polygon[i][1]);
    const nextPoint = polygon[(i + 1) % polygon.length];
    ctx.lineTo(nextPoint[0], nextPoint[1]);
    ctx.stroke();
  }
}

const polygon = [
  [1, 1],
  [1, 100],
  [100, 100],
  [100, 1],
];

drawPolygon(polygon);
