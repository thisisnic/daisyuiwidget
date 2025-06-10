HTMLWidgets.widget({

  name: 'daisyTimeline',

  type: 'output',

  factory: function(el, width, height) {

    return {
      renderValue: function(x) {
  el.innerHTML = "";

  // Insert the CSS needed for the timeline component
  if (!document.getElementById('daisyui-timeline-css')) {
  const style = document.createElement('style');
  style.id = 'daisyui-timeline-css';
  style.textContent = `
    .timeline {
      display: flex;
      flex-direction: column;
      padding-left: 2rem;
      position: relative;
      margin: 2rem 0;
    }
    .timeline::before {
      content: '';
      position: absolute;
      left: 1rem;
      top: 0;
      bottom: 0;
      width: 2px;
      background-color: #d1d5db; /* tailwind gray-300 */
    }
    .timeline li {
      position: relative;
      display: flex;
      align-items: flex-start;
      margin-bottom: 2rem;
    }
    .timeline-start {
      font-size: 0.875rem;
      color: #6b7280; /* tailwind gray-500 */
      min-width: 6rem;
      margin-right: 1rem;
    }
    .timeline-middle {
      position: absolute;
      left: 0.75rem;
      width: 0.75rem;
      height: 0.75rem;
      background-color: #2563eb; /* tailwind blue-600 */
      border-radius: 9999px;
      border: 2px solid white;
      box-shadow: 0 0 0 2px #2563eb;
      top: 0.25rem;
    }
    .timeline-end {
      flex: 1;
    }
    .timeline-box {
      background-color: white;
      padding: 1rem;
      border: 1px solid #e5e7eb;
      border-radius: 0.5rem;
      box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
      font-size: 0.95rem;
    }
  `;
  document.head.appendChild(style);
}


  // Build HTML
  const ul = document.createElement("ul");
  ul.className = "timeline";
  x.events.forEach(event => {
    const li = document.createElement("li");
    const start = document.createElement("div");
    start.className = "timeline-start";
    start.textContent = event.date;

    const middle = document.createElement("div");
    middle.className = "timeline-middle";

    const end = document.createElement("div");
    end.className = "timeline-end";
    const box = document.createElement("div");
    box.className = "timeline-box";
    box.textContent = event.content;

    end.appendChild(box);
    li.appendChild(start);
    li.appendChild(middle);
    li.appendChild(end);
    ul.appendChild(li);
  });

  el.appendChild(ul);
}

    };
  }
});
