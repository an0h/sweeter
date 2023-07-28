let RequiredTags = {
    init(socket) {
        let channel = socket.channel('reactions:lobby', {})
        channel.join()
        this.listenForReactions(channel)
    },

    listenForReactions(channel) {
        const rootElement = document.querySelector('#emoji-trigger');
        const picker = createPicker({ rootElement });

        picker.addEventListener('emoji:select', event => {
            console.log(event)
            
            const yourreaction = document.getElementById('your-reaction');   
            yourreaction.innerHTML = event.emoji
            
            let item_id = document.getElementById('item_id').value
            let address = document.getElementById('address').value
            channel.push('react', {
                'item_id': item_id,
                'address': address,
                'emoji': event.emoji,
                'description': event.label
            })
        })
    }
}

export default RequiredTags
