```mermaid
classDiagram
    class ContentCard {
        +ContentItem item
        +VoidCallback? onTap
        +ContentCard(item, onTap)
        +Widget build(context)
    }

    class ContentItem {
        +String image
        +String title
        +String description
        +String url
        +ContentItem(image, title, description, url)
        +fromMap(map) ContentItem
        +toMap() Map<String, dynamic>
    }

    ContentCard --> ContentItem : uses

