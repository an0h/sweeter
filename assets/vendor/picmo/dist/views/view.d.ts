import { Template, TemplateData } from '../Template';
import { AppEvent, AppEventKey } from '../AppEvents';
import { Events, EventArgs, EventCallback, AsyncEventCallback } from '../events';
import { ViewFactory } from '../viewFactory';
import { Bundle } from '../i18n/bundle';
import { Renderer } from '../renderers/renderer';
import { DataStore } from '../data/DataStore';
import { EmojiRecord, PickerOptions } from '../types';
declare type UIEventListenerBinding = {
    target?: string;
    event: string;
    handler: EventCallback;
    options?: AddEventListenerOptions;
};
declare type KeyBindings = Record<string, (KeyboardEvent?: any) => void>;
declare type AppEvents = {
    [key in AppEvent]?: EventCallback | AsyncEventCallback;
};
declare type ClassMappings = Record<string, string>;
declare type UIElementSelectors = Record<string, string>;
declare type UIElementMappings = Record<string, HTMLElement>;
declare type ViewOptions = {
    template: Template;
    classes?: ClassMappings;
    parent?: HTMLElement;
};
export declare abstract class View {
    el: HTMLElement;
    isDestroyed: boolean;
    private template;
    private classes?;
    protected appEvents: AppEvents;
    protected uiEvents: UIEventListenerBinding[];
    protected keyBindings: KeyBindings;
    protected uiElements: UIElementSelectors;
    protected emojiData: DataStore;
    protected emojiDataPromise: Promise<DataStore>;
    protected options: PickerOptions;
    protected customEmojis: EmojiRecord[];
    protected events: Events<AppEvent>;
    protected i18n: Bundle;
    protected renderer: Renderer;
    protected pickerId: string;
    protected parent?: HTMLElement;
    viewFactory: ViewFactory;
    ui: UIElementMappings;
    constructor({ template, classes, parent }: ViewOptions);
    initialize(): void;
    setCustomEmojis(customEmojis: EmojiRecord[]): void;
    setEvents(events: Events<AppEvent>): void;
    setPickerId(pickerId: string): void;
    emit(event: AppEventKey, ...args: EventArgs): void;
    setI18n(i18n: Bundle): void;
    setRenderer(renderer: Renderer): void;
    setEmojiData(emojiDataPromise: Promise<DataStore>): void;
    updateEmojiData(emojiData: DataStore): void;
    setOptions(options: PickerOptions): void;
    animateShow?: () => Promise<Animation | void | Animation[] | (Animation | void)[]>;
    renderSync(templateData?: TemplateData): HTMLElement;
    render(templateData?: TemplateData): Promise<HTMLElement>;
    private postRender;
    private bindAppEvents;
    private unbindAppEvents;
    private keyBindingHandler;
    private bindKeyBindings;
    private unbindKeyBindings;
    private bindUIElements;
    private bindUIEvents;
    private unbindUIEvents;
    destroy(): void;
    private scheduleShowAnimation;
    static childEvent(target: string, event: string, handler: EventCallback, options?: AddEventListenerOptions): UIEventListenerBinding;
    static uiEvent(event: string, handler: EventCallback, options?: AddEventListenerOptions): UIEventListenerBinding;
    static byClass(className: string): string;
}
export {};
