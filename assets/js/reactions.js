// import { EmojiButton } from '@joeattardi/emoji-button'

let Reactions = {
    init(socket) {
        let channel = socket.channel('cooler:lobby', {})
        channel.join()
        this.listenForReactions(channel)
        this.listenForItemModeration(channel)
    },

    listenForReactions(channel) {
        const picker = new EmojiButton();
        const trigger = document.querySelector('#emoji-trigger')

        picker.on('emoji', selection => {
            // handle the selected emoji here
            let item_id = document.getElementById('item_id').value
            channel.push('react', {
                'item_id': item_id,
                'emoji': selection.emoji,
                'description': selection.name
            })
        })
        trigger.addEventListener('click', () => picker.togglePicker(trigger))

        channel.on('react', payload => {
            let reaction = document.querySelector('#reactions')
            let msgBlock = document.createElement('p')

            msgBlock.insertAdjacentHTML('beforeend', `${payload.emoji}`)
            reaction.appendChild(msgBlock)
        })
    }
}

export default Reactions