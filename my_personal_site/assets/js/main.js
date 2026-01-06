document.addEventListener("DOMContentLoaded", function() {
    loadNavbar();
});

function loadNavbar() {
    const placeholder = document.getElementById('navbar-placeholder');
    if (!placeholder) return;

    fetch('/assets/components/nav.html')
        .then(response => {
            if (!response.ok) throw new Error("Failed to load nav");
            return response.text();
        })
        .then(html => {
            placeholder.innerHTML = html;
            setActiveTab();
        })
        .catch(err => console.error('Error loading navigation:', err));
}

function setActiveTab() {
    const path = window.location.pathname;
    
    // Default to 'home' if path is root or index.html
    let activeId = 'nav-home';

    if (path.includes('/projects/')) {
        activeId = 'nav-projects';
    } else if (path.includes('/about/')) {
        activeId = 'nav-about';
    }

    const activeLink = document.getElementById(activeId);
    if (activeLink) {
        activeLink.classList.add('active');
    }
}